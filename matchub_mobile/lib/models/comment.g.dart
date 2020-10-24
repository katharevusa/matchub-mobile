// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment()
    ..commentId = json['commentId'] as num
    ..timeCreated = DateTime.parse(json['timeCreated'])
    ..content = json['content'] as String
    ..accountId = json['accountId'] as num
    ..commentType = json['commentType'] as String;
}

