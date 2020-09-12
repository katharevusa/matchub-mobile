import 'package:flutter/material.dart';

class Project with ChangeNotifier {
  int projectId;
  String projectTitle;
  String projectDescription;
  String country;
  DateTime startDate;
  DateTime endDate;
  int upvotes = 0;
  ProjectStatusEnum projStatus = ProjectStatusEnum.ON_HOLD;
  List<int> userFollowers = [];
  List<String> photos = [];
  List<String> relatedResources = [];
  int projCreatorId;

  Project(
      {this.projectId,
      this.projectTitle,
      this.projectDescription,
      this.country,
      this.startDate,
      this.endDate,
      this.upvotes,
      this.projStatus,
      this.userFollowers,
      this.photos,
      this.projCreatorId,
      this.relatedResources});

  // Boolean spotlight = false;

  // LocalDateTime spotlightEndTime;

  // List<JoinRequestEntity> joinRequests = new ArrayList<>();

  // List<ReviewEntity> reviews = new ArrayList<>();

  // BadgeEntity projectBadge;

  // List<FundsCampaignEntity> fundsCampaign = new ArrayList<>();

  // List<ScheduleEntity> meetings = new ArrayList<>();

  // List<ResourceRequestEntity> listOfRequests = new ArrayList<>();

  // List<SDGEntity> sdgs = new ArrayList<>();

  // List<KPIEntity> kpis = new ArrayList<>();

  // List<ProfileEntity> teamMembers = new ArrayList<>();

  // List<ChannelEntity> channels = new ArrayList<>();

  // List<ProfileEntity> projectOwners = new ArrayList<>();

}

enum ProjectStatusEnum { ACTIVE, COMPLETED, ON_HOLD }
