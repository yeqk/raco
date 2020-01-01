import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:raco/src/blocs/events/events.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/raco_api_client.dart';
import 'package:raco/src/repositories/raco_repository.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/ui/routes/bottom_navigation/events_route.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:http/http.dart' as http;

class EventsBloc extends Bloc<EventsEvent, EventsState> {

  EventsState get initialState => EventsInitState();

  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    if (event is EventsInitEvent) {
      yield EventsInitState();
    }
    if (event is EventsDeleteEvent) {
      EventItem item = event.item;
      Dme().customEvents.results.removeWhere((i) {
        return i.id == item.customId;
      });
      Dme().customEvents.count -= 1;
      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_EVENTS,
          jsonEncode(Dme().customEvents));
      yield EventDeletedState();
    }

    if (event is EventsChangedEvent) {
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
          await ReadWriteFile()
              .writeStringToFile(FileNames.EVENTS, jsonEncode(events));
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
