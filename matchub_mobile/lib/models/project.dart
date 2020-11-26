import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/campaign.dart';

import 'index.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  Project();

  num projectId;
  String projectTitle;
  String projectDescription;
  String country;
  DateTime startDate;
  DateTime endDate;
  List userFollowers;
  String projStatus;
  num upvotes;
  List relatedResources;
  num projCreatorId;
  bool spotlight;
  String spotlightEndTime;
  String projectProfilePic;
  List photos;
  Map<String, dynamic> documents;
  List joinRequests;
  List reviews;
  Badge projectBadge;
  List<Campaign> fundsCampaign;
  List meetings;
  List listOfRequests;
  num reputationPoints;
  num projectPoolPoints;
  List sdgs;
  List kpis;
  List<TruncatedProfile> teamMembers;
  List<TruncatedProfile> projectFollowers;
  List channels;
  List<TruncatedProfile> projectOwners;
  List<SelectedTarget> selectedTargets;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
