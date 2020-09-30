import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'project.g.dart';

@JsonSerializable()
class Project with ChangeNotifier {
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
    Map<String,dynamic> documents;
    List<JoinRequest> joinRequests;
    List reviews;
    String projectBadge;
    List fundsCampaign;
    List meetings;
    List listOfRequests;
    List sdgs;
    List kpis;
    List<TruncatedProfile> teamMembers;
    List channels;
    List<TruncatedProfile> projectOwners;
    
    factory Project.fromJson(Map<String,dynamic> json) => _$ProjectFromJson(json);
    Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
