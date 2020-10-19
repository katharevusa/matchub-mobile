// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resourceCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceCategory _$ResourceCategoryFromJson(Map<String, dynamic> json) {
  return ResourceCategory()
    ..resourceCategoryId = json['resourceCategoryId'] as num
    ..resourceCategoryName = json['resourceCategoryName'] as String;
    // ..resourceCategoryDescription =
    //     json['resourceCategoryDescription'] as String
    // ..resources = json['resources'] as List
    // ..communityPointsGuideline = json['communityPointsGuideline'] as num
    // ..perUnit = json['perUnit'] as num
    // ..unitName = json['unitName'] as String;
}

Map<String, dynamic> _$ResourceCategoryToJson(ResourceCategory instance) =>
    <String, dynamic>{
      'resourceCategoryId': instance.resourceCategoryId,
      'resourceCategoryName': instance.resourceCategoryName,
      'resourceCategoryDescription': instance.resourceCategoryDescription,
      'resources': instance.resources,
      'communityPointsGuideline': instance.communityPointsGuideline,
      'perUnit': instance.perUnit,
      'unitName': instance.unitName
    };
