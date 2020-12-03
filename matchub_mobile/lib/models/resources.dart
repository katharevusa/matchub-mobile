import 'package:json_annotation/json_annotation.dart';

part 'resources.g.dart';

@JsonSerializable()
class Resources {
  Resources();

  num resourceId;
  String resourceName;
  String resourceDescription;
  String resourceProfilePic;
  num matchedProjectId;
  List uploadedFiles;
  bool available;
  String startTime;
  String endTime;
  List listOfRequests;
  num resourceCategoryId;
  num resourceOwnerId;
  num units;
  List photos;
  bool spotlight;
  String spotlightEndTime;
  String country;
  double price;
  String resourceType;

  factory Resources.fromJson(Map<String, dynamic> json) =>
      _$ResourcesFromJson(json);
  Map<String, dynamic> toJson() => _$ResourcesToJson(this);
}
