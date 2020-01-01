import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NoticeState extends Equatable {
  NoticeState([List props = const []]) : super(props);
}

class NoticeInitState extends NoticeState {

  @override
  String toString() => 'NoticeInitState';
}

class NoticeAttachmentDownloadSuccessfullyState extends NoticeState {

  @override
  String toString() => 'NoticeAttachmentDownloadSuccessfullyState';
}

class NoticeAttachmentDownloadErrorState extends NoticeState {
  @override
  String toString() => 'NoticeAttachmentDownloadErrorState';
}

class NoticeAttachmentDownloadingState extends NoticeState {
  @override
  String toString() => 'NoticeAttachmentDownloadingState';
}