import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:raco/src/blocs/notice/notice.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/custom_downloads.dart';
import 'package:raco/src/models/models.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:share_extend/share_extend.dart';

class NoticeRoute extends StatefulWidget {
  final Avis avis;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  NoticeRoute({Key key, @required this.avis}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoticeRouteState();
  }
}

class NoticeRouteState extends State<NoticeRoute> {
  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (Dme().assigURL[widget.avis.codiAssig] != null &&
        Dme().assigURL[widget.avis.codiAssig].nom != null &&
        Dme().assigURL[widget.avis.codiAssig].nom != ' ') {
      appBarTitle = Dme().assigURL[widget.avis.codiAssig].nom;
    } else {
      appBarTitle = widget.avis.codiAssig;
    }

    ProgressDialog pr = new ProgressDialog(context, isDismissible: true);
    pr.style(
      message: allTranslations.text('downloading'),
    );

    DateFormat format = DateFormat('yyyy-M-dTH:m:s');
    var formatter = new DateFormat.yMMMMd(allTranslations.currentLanguage);
    DateTime ta = format.parse(widget.avis.dataModificacio);
    String time = formatter.format(ta);
    return Scaffold(
        key: widget._scaffoldKey,
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text(widget.avis.titol),
                    subtitle: Text(time),
                  ),
                ),
                Expanded(
                    child: Card(
                        child: Container(
                  padding: EdgeInsets.all(10),
                  child:
                      ListView(children: _noticeBody(pr, widget.avis, context)),
                )))
              ],
            )));
  }

  List<Widget> _noticeBody(ProgressDialog pr, Avis avis, BuildContext context) {
    List<Widget> body = new List();
    if (avis.adjunts.length > 0) {
      body.add(_attachments(pr, avis, context));
    }
    body.add(Html(
      data: avis.text,
      onLinkTap: (url) => _onLinkTap(url),
    ));
    return body;
  }

  Widget _attachments(ProgressDialog pr, Avis avis, BuildContext context) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: BlocBuilder<NoticeBloc, NoticeState>(
            builder: (context, state) {
              final _noticeBloc = BlocProvider.of<NoticeBloc>(context);
              if (state is NoticeAttachmentDownloadErrorState) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _showMessage('Error', context));
                _noticeBloc.dispatch(NoticeInitEvent());
              } else if (state is NoticeAttachmentDownloadingState) {
                WidgetsBinding.instance.addPostFrameCallback((_) => pr.show());

                _noticeBloc.dispatch(NoticeInitEvent());
              } else if (state is NoticeAttachmentDownloadSuccessfullyState) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => pr.dismiss());

                _noticeBloc.dispatch(NoticeInitEvent());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(avis.adjunts.length.toString() +
                      ' ' +
                      allTranslations.text('attachments') +
                      ' :'),
                  Column(children: _attachedFiles(_noticeBloc, avis, context))
                ],
              );
            },
          )),
    );
  }

  void _showMessage(String msg, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  List<Widget> _attachedFiles(
      var _noticeBloc, Avis avis, BuildContext context) {
    List<Widget> files = new List();
    for (Adjunt adjunt in avis.adjunts) {
      files.add(RaisedButton(
        onPressed: () => _downloadFile(_noticeBloc, adjunt, context),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: FittedBox(
          child: Dme().customDownloads.name.contains(adjunt.nom)
              ? Row(
                  children: <Widget>[
                    Text(adjunt.nom + ' (' + fileSize(adjunt.mida) + ') '),
                    Icon(Icons.offline_pin)
                  ],
                )
              : Text(adjunt.nom + ' (' + fileSize(adjunt.mida) + ')'),
        ),
      ));
    }
    return files;
  }

  String fileSize(int bytes) {
    if (bytes < 1024) {
      return bytes.toStringAsFixed(2) + ' Bytes';
    } else if (bytes / 1024 < 1024) {
      return (bytes / 1024).toStringAsFixed(2) + ' KB';
    } else if (bytes / 1024 / 1024 < 1024) {
      return (bytes / 1024 / 1024).toStringAsFixed(2) + ' MB';
    } else {
      return (bytes / 1024 / 1024 / 1024).toStringAsFixed(2) + ' GB';
    }
  }

  void _downloadFile(
      var _noticeBloc, Adjunt adjunt, BuildContext context) async {
    _noticeBloc.dispatch(NoticeDownloadAttachmentEvent(adjunt: adjunt));

    /*  try {
      String accessToken = await user.getAccessToken();
      String lang = await user.getPreferredLanguage();
      RacoRepository rr = new RacoRepository(
          racoApiClient: RacoApiClient(
              httpClient: http.Client(), accessToken: accessToken, lang: lang));
      String filePath = '';
      if (await ReadWriteFile().exists(adjunt.nom)) {
        filePath = await ReadWriteFile().getPaht(adjunt.nom);
        if (adjunt.tipusMime == 'application/pdf') {
          await OpenFile.open(filePath);
        } else {
          await ShareExtend.share(filePath, adjunt.nom);
        }
      } else {
        ProgressDialog pr = new ProgressDialog(context, isDismissible: true);
        pr.style(
          message: allTranslations.text('downloading'),
        );
        pr.show();
        try {
          filePath = await rr.downloadAndSaveFile(
              adjunt.nom, adjunt.url, adjunt.tipusMime);
          Dme().customDownloads.count += 1;
          Dme().customDownloads.name.add(adjunt.nom);
          await ReadWriteFile().writeStringToFile(
              FileNames.CUSTOM_DOWNLOADS,
              jsonEncode(Dme().customDownloads));
          setState(() {

          });
          pr.dismiss();
          if (adjunt.tipusMime == 'application/pdf') {
            await OpenFile.open(filePath);
          } else {
            await ShareExtend.share(filePath, adjunt.nom);
          }
        } catch (e) {
          pr.dismiss();
          widget._scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Error'),
          ));
        }
      }
    } catch (e) {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Error'),
      ));
    }*/
  }

  _onLinkTap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
