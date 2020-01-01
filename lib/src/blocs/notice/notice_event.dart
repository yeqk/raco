import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:raco/src/models/avisos.dart';

abstract class NoticeEvent extends Equatable {
  NoticeEvent([List props = const []]) : super(props);
}

class NoticeInitEvent extends NoticeEvent {

  NoticeInitEvent();
  @override
  String toString() =>
      'NoticeInitEvent';
}


class NoticeDownloadAttachmentEvent extends NoticeEvent {
  final Adjunt adjunt;
  NoticeDownloadAttachmentEvent({@required this.adjunt}) : super([adjunt]);
  @override
  String toString() =>
      'NoticeDownloadAttachmentEvent';
}
