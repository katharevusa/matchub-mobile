// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badge _$BadgeFromJson(Map<String, dynamic> json) {
  return Badge()
    ..badgeId = json['badgeId'] as num
    ..badgeType = json['badgeType'] as String
    ..badgeTitle = json['badgeTitle'] as String
    ..icon = json['icon'] as String
    ..project = json['project'] as Map<String, dynamic>;
}

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
      'badgeId': instance.badgeId,
      'badgeType': instance.badgeType,
      'badgeTitle': instance.badgeTitle,
      'icon': instance.icon,
      'project': instance.project
    };
