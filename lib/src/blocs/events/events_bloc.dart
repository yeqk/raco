import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:oauth2/oauth2.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/blocs/events/events.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/db_helpers/custom_event_helper.dart';
import 'package:raco/src/models/db_helpers/event_helper.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/db_repository.dart';
import 'package:raco/src/repositories/raco_api_client.dart';
import 'package:raco/src/repositories/raco_repository.dart';
import 'package:raco/src/resources/authentication_data.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/ui/routes/bottom_navigation/events_route.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:http/http.dart' as http;

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final AuthenticationBloc authenticationBloc;

  EventsBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  EventsState get initialState => EventsInitState();

  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    if (event is EventsInitEvent) {
      yield EventsInitState();
    }

    if (event is EventsAddEvent) {
      Dme().customEvents.count += 1;
      Dme().customEvents.results.add(event.customEvent);
/*      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_EVENTS, jsonEncode(Dme().customEvents));*/
      await dbRepository.insertCustomEventHelper(CustomEventHelper.fromCustomEvent(event.customEvent, Dme().username));
      yield EventAddedState();
    }

    if (event is EventsDeleteEvent) {
      EventItem item = event.item;
      Dme().customEvents.results.removeWhere((i) {
        return i.id == item.customId;
      });
      Dme().customEvents.count -= 1;
      await dbRepository.deleteCustomerEventById(item.customId);
/*      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_EVENTS,
          jsonEncode(Dme().customEvents));*/
      yield EventDeletedState();
    }

    if (event is EventsEditEvent) {
      CustomEvent customEvent = event.customEvent;
      EventItem item = event.eventItem;
      Dme().customEvents.results.removeWhere((i) {
        return i.id == item.customId;
      });
      Dme().customEvents.results.add(customEvent);
      await dbRepository.clearCustomEventHelperTable();
      Dme().customEvents.results.forEach((ce) async {
        await dbRepository.insertCustomEventHelper(CustomEventHelper.fromCustomEvent(ce, Dme().username));
      });
  /*    await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_EVENTS,
          jsonEncode(Dme().customEvents));*/
      yield EventEditedState();
    }

    if (event is EventsChangedEvent) {
      Credentials c = await user.getCredentials();
      try {
        if(c.isExpired ) {
          c = await c.refresh(identifier: AuthenticationData.identifier,secret: AuthenticationData.secret,);
          await user.persistCredentials(c);
        }
      } catch(e) {
        authenticationBloc.dispatch(LoggedOutEvent());
      }
//update events
      bool canUpdate = true;
      if (await user.isPresentInPreferences(Keys.LAST_EVENTS_REFRESH)) {
        if (DateTime.now()
            .difference(DateTime.parse(
            await user.readFromPreferences(Keys.LAST_EVENTS_REFRESH)))
            .inMinutes <
            5) {
          canUpdate = false;
        }
      }
      if (canUpdate) {
        try {
          String accessToken = await user.getAccessToken();
          String lang = await user.getPreferredLanguage();
          RacoRepository rr = new RacoRepository(
              racoApiClient: RacoApiClient(
                  httpClient: http.Client(),
                  accessToken: accessToken,
                  lang: lang));
          Events events = await rr.getEvents();
        /*  await ReadWriteFile()
              .writeStringToFile(FileNames.EVENTS, jsonEncode(events));*/
          dbRepository.clearEventHelperTable();
          events.results.forEach((e) async {
            await dbRepository.insertEventHelper(EventHelper.fromEvent(e));
          });
          Dme().events = events;
          user.writeToPreferences(
              Keys.LAST_EVENTS_REFRESH, DateTime.now().toIso8601String());
          yield UpdateEventsSuccessfullyState();
        } catch (e) {
          yield UpdateEventsErrorState();
        }
      } else {
        yield UpdateEventsTooFrequentlyState();
      }
    }
  }
}
