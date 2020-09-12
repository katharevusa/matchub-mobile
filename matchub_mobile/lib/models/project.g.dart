// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project()
    ..projectId = json['projectId'] as num
    ..projectTitle = json['projectTitle'] as String
    ..projectDescription = json['projectDescription'] as String
    ..country = json['country'] as String
    ..startDate = json['startDate'] as String
    ..endDate = json['endDate'] as String
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
    ..sdgs = json['sdgs'] as List
    ..kpis = json['kpis'] as List
    ..teamMembers = json['teamMembers'] as List
    ..channels = json['channels'] as List
    ..projectOwners = json['projectOwners'] as List;
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'projectId': instance.projectId,
      'projectTitle': instance.projectTitle,
      'projectDescription': instance.projectDescription,
      'country': instance.country,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'userFollowers': instance.userFollowers,
      'projStatus': instance.projStatus,
      'upvotes': instance.upvotes,
      'photos': instance.photos,
      'relatedResources': instance.relatedResources,
      'projCreatorId': instance.projCreatorId,
      'spotlight': instance.spotlight,
      'spotlightEndTime': instance.spotlightEndTime,
      'joinRequests': instance.joinRequests,
      'reviews': instance.reviews,
      'projectBadge': instance.projectBadge,
      'fundsCampaign': instance.fundsCampaign,
      'meetings': instance.meetings,
      'listOfRequests': instance.listOfRequests,
      'sdgs': instance.sdgs,
      'kpis': instance.kpis,
      'teamMembers': instance.teamMembers,
      'channels': instance.channels,
      'projectOwners': instance.projectOwners
    };
