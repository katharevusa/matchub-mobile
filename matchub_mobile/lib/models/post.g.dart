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
    ..originalPostId = json['originalPostId'] as String
    ..previousPostId = json['previousPostId'] as String
    ..likes = json['likes'] as num
    ..postCreatorId = json['postCreatorId'] as String
    ..listOfComments = json['listOfComments'] as List;
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'postId': instance.postId,
      'content': instance.content,
      'timeCreated': instance.timeCreated,
      'photos': instance.photos,
      'originalPostId': instance.originalPostId,
      'previousPostId': instance.previousPostId,
      'likes': instance.likes,
      'postCreatorId': instance.postCreatorId,
      'listOfComments': instance.listOfComments
    };
