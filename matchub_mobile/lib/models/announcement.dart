import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  Announcement();

  num announcementId;
  String title;
  String content;
  DateTime timestamp;
  List notifiedUsers;
  num projectId;
  String taskId;
  String postId;
  String type;
  List viewedUserIds;
  num creatorId;

  num resourceId;
  num resourceRequestId;
  num joinRequestId;
  String newFollowerAndNewPosterUUID;
  num newFollowerAndNewPosterProfileId;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
