import 'package:json_annotation/json_annotation.dart';

part 'custom_downloads.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomDownloads {
  int count;
  List<String> name;

  CustomDownloads(this.count, this.name);

  factory CustomDownloads.fromJson(Map<String, dynamic> json) =>
      _$CustomDownloadsFromJson(json);

  Map<String, dynamic> toJson() => _$CustomDownloadsToJson(this);
}
