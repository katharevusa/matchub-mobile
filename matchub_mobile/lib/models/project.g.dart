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
    ..projectProfilePic = json['projectProfilePic'] ?? ""
    ..country = json['country'] as String
    ..startDate = DateTime.parse(json['startDate'])
    ..endDate = DateTime.parse(json['endDate'])
    ..userFollowers = json['userFollowers'] as List
    ..projStatus = json['projStatus'] as String
    ..upvotes = json['upvotes'] as num
    ..relatedResources = json['relatedResources'] as List
    ..projCreatorId = json['projCreatorId'] as num
    ..spotlight = json['spotlight'] as bool
    ..spotlightEndTime = json['spotlightEndTime'] ?? ""
    ..photos = json['photos'] as List
    ..documents = json['documents'] as Map<String, dynamic>
    ..joinRequests = json['joinRequests'] != null
        ? (json['joinRequests'] as List)
            .map((i) => JoinRequest.fromJson(i))
            .toList()
        : []
    ..reviews = json['reviews'] as List
    ..projectBadge = json['projectBadge'] != null
        ? Badge.fromJson(json['projectBadge'])
        : null
    ..fundsCampaign = json['fundsCampaign'] as List
    ..meetings = json['meetings'] as List
    ..listOfRequests = json['listOfRequests'] as List
    ..sdgs = json['sdgs'] != null
        ? (json['sdgs'] as List).map((i) => Sdg.fromJson(i)).toList()
        : []
    ..kpis = json['kpis'] as List
    ..teamMembers = json['teamMembers'] != null
        ? (json['teamMembers'] as List)
            .map((i) => TruncatedProfile.fromJson(i))
            .toList()
        : []
    ..projectFollowers = json['projectFollowers'] != null
        ? (json['projectFollowers'] as List)
            .map((i) => TruncatedProfile.fromJson(i))
            .toList()
        : []
    ..channels = json['channels'] as List
    ..projectOwners = json['projectOwners'] != null
        ? (json['projectOwners'] as List)
            .map((i) => TruncatedProfile.fromJson(i))
            .toList()
        : [];
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
      'relatedResources': instance.relatedResources,
      'projCreatorId': instance.projCreatorId,
      'spotlight': instance.spotlight,
      'spotlightEndTime': instance.spotlightEndTime,
      'projectProfilePic': instance.projectProfilePic,
      'photos': instance.photos,
      'documents': instance.documents,
      'joinRequests': instance.joinRequests,
      'reviews': instance.reviews,
      'projectBadge': instance.projectBadge,
      'fundsCampaign': instance.fundsCampaign,
      'meetings': instance.meetings,
      'listOfRequests': instance.listOfRequests,
      'sdgs': instance.sdgs,
      'kpis': instance.kpis,
      'teamMembers': instance.teamMembers,
      'projectFollowers': instance.projectFollowers,
      'channels': instance.channels,
      'projectOwners': instance.projectOwners
    };
