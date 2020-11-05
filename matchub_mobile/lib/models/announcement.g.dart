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
    ..taskId = json['taskId'] as num
    ..postId = json['postId'] as num
    ..type = json['type'] as String
    ..viewedUserIds = json['viewedUserIds'] as List
    ..creatorId = json['creatorId'] as num
    ..resourceId = json['resourceId'] as num
    ..resourceRequestId = json['resourceRequestId'] as num
    ..joinRequestId = json['joinRequestId'] as num
    ..newFollowerAndNewPosterUUID =
        json['newFollowerAndNewPosterUUID'] as String
    ..newFollowerAndNewPosterProfileId =
        json['newFollowerAndNewPosterProfileId'] as num;
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
      'creatorId': instance.creatorId,
      'resourceId': instance.resourceId,
      'resourceRequestId': instance.resourceRequestId,
      'joinRequestId': instance.joinRequestId,
      'newFollowerAndNewPosterUUID': instance.newFollowerAndNewPosterUUID,
      'newFollowerAndNewPosterProfileId':
          instance.newFollowerAndNewPosterProfileId
    };
