import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/sdg.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  Project();

  num projectId;
  String projectTitle;
  String projectDescription;
  String country;
  String startDate;
  String endDate;
  List userFollowers;
  String projStatus;
  num upvotes;
  List photos;
  List relatedResources;
  num projCreatorId;
  bool spotlight;
  String spotlightEndTime;
  List joinRequests;
  List reviews;
  String projectBadge;
  List fundsCampaign;
  List meetings;
  List listOfRequests;
  List sdgs;
  List kpis;
  List teamMembers;
  List channels;
  List projectOwners;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project()
      ..projectId = json['projectId'] as num
      ..projectTitle = json['projectTitle'] as String ?? ""
      ..projectDescription = json['projectDescription'] as String ?? ""
      ..country = json['country'] as String ?? ""
      ..startDate = json['startDate'] as String ?? ""
      ..endDate = json['endDate'] as String ?? ""
      ..userFollowers = json['userFollowers'] as List
      ..projStatus = json['projStatus'] as String
      ..upvotes = json['upvotes'] as num
      ..photos = json['photos'] as List
      ..relatedResources = json['relatedResources'] as List
      ..projCreatorId = json['projCreatorId'] as num
      ..spotlight = json['spotlight'] as bool
      ..spotlightEndTime = json['spotlightEndTime'] as String
      ..joinRequests = json['joinRequests'] as List
      ..reviews = json['reviews'] as List
      ..projectBadge = json['projectBadge'] as String
      ..fundsCampaign = json['fundsCampaign'] as List
      ..meetings = json['meetings'] as List
      ..listOfRequests = json['listOfRequests'] as List
      ..sdgs = (json['sdgs'] as List).map((i) => Sdg.fromJson(i)).toList()
      ..kpis = json['kpis'] as List
      ..teamMembers = json['teamMembers'] as List
      ..channels = json['channels'] as List
      ..projectOwners = json['projectOwners'] as List;
  }

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
