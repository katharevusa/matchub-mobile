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
    ..resourceProfilePic = json['resourceProfilePic'] ?? ""
    ..uploadedFiles = json['uploadedFiles'] as List
    ..available = json['available'] as bool
    ..startTime = json['country'] ?? ""
    ..startTime = json['startTime'] as String
    ..endTime = json['endTime'] as String
    ..listOfRequests = json['listOfRequests'] as List
    ..resourceCategoryId = json['resourceCategoryId'] as num
    ..resourceOwnerId = json['resourceOwnerId'] as num
    ..units = json['units'] as num
    ..photos = json['photos'] as List
    ..spotlight = json['spotlight'] as bool
    ..spotlightEndTime = json['spotlightEndTime'] ?? ""
    ..matchedProjectId = json['matchedProjectId'] as num
    ..country = json['country'] as String
    ..price = json['price'] as double
    ..resourceType = json['resourceType'] as String;
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
      'resourceCategoryId': instance.resourceCategoryId,
      'resourceOwnerId': instance.resourceOwnerId,
      'units': instance.units,
      'photos': instance.photos,
      'spotlight': instance.spotlight,
      'spotlightEndTime': instance.spotlightEndTime,
      'matchedProjectId': instance.matchedProjectId,
      'country': instance.country,
      'price': instance.price,
      'resourceType': instance.resourceType,
    };
