// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) {
  return Announcement()
    ..announcementId = json['announcementId'] as num
    ..title = json['title'] as String
    ..content = json['content'] as String
    ..timestamp = DateTime.parse(json['timestamp'])
    ..notifiedUsers = json['notifiedUsers'] as List
    ..projectId = json['projectId'] as num
    ..taskId = json['taskId'] as String
    ..postId = json['postId'] as String
    ..type = json['type'] as String
    ..viewedUserIds = json['viewedUserIds'] as List
    ..creatorId = json['creatorId'] as num;
}

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'announcementId': instance.announcementId,
      'title': instance.title,
      'content': instance.content,
      'timestamp': instance.timestamp,
      'notifiedUsers': instance.notifiedUsers,
      'projectId': instance.projectId,
      'taskId': instance.taskId,
      'postId': instance.postId,
      'type': instance.type,
      'viewedUserIds': instance.viewedUserIds,
      'creatorId': instance.creatorId
    };