// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post()
    ..postId = json['postId'] as num
    ..content = json['content'] as String
    ..timeCreated = DateTime.parse(json['timeCreated'])
    ..photos = json['photos'] as List
    ..originalPostId = json['originalPostId'] as num
    ..previousPostId = json['previousPostId'] as num
    ..likes = json['likes'] as num
    ..likedUsersId = json['likedUsersId'] as List
    ..postCreator = Profile.fromJson(json['postCreator'])
    ..listOfComments =  json['listOfComments'] != null
        ? (json['listOfComments'] as List)
            .map((i) => Comment.fromJson(i))
            .toList()
        : [];
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'postId': instance.postId,
      'content': instance.content,
      'timeCreated': instance.timeCreated,
      'photos': instance.photos,
      'originalPostId': instance.originalPostId,
      'previousPostId': instance.previousPostId,
      'likes': instance.likes,
      'postCreator': instance.postCreator,
      'listOfComments': instance.listOfComments
    };
