import 'package:json_annotation/json_annotation.dart';

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
    
    factory Project.fromJson(Map<String,dynamic> json) => _$ProjectFromJson(json);
    Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
