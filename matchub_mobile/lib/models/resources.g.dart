// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resources.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resources _$ResourcesFromJson(Map<String, dynamic> json) {
  return Resources()
    ..resourceId = json['resourceId'] as num
    ..resourceName = json['resourceName'] as String
    ..resourceDescription = json['resourceDescription'] as String
    ..uploadedFiles = json['uploadedFiles'] as List
    ..available = json['available'] as bool
    ..startTime = json['startTime'] as String
    ..endTime = json['endTime'] as String
    ..listOfRequests = json['listOfRequests'] as List
    ..resourceCategory = json['resourceCategory'] as Map<String, dynamic>
    ..resourceOwner = json['resourceOwner'] as Map<String, dynamic>
    ..units = json['units'] as num
    ..photos = json['photos'] as List
    ..spotlight = json['spotlight'] as bool
    ..spotlightEndTime = json['spotlightEndTime'] as String
    ..matchedProjectId = json['matchedProjectId'] as String;
}

Map<String, dynamic> _$ResourcesToJson(Resources instance) => <String, dynamic>{
      'resourceId': instance.resourceId,
      'resourceName': instance.resourceName,
      'resourceDescription': instance.resourceDescription,
      'uploadedFiles': instance.uploadedFiles,
      'available': instance.available,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'listOfRequests': instance.listOfRequests,
      'resourceCategory': instance.resourceCategory,
      'resourceOwner': instance.resourceOwner,
      'units': instance.units,
      'photos': instance.photos,
      'spotlight': instance.spotlight,
      'spotlightEndTime': instance.spotlightEndTime,
      'matchedProjectId': instance.matchedProjectId
    };
