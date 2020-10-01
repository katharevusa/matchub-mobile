// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review()
    ..reviewId = json['reviewId'] as num
    ..timeCreated = json['timeCreated'] as String
    ..content = json['content'] as String
    ..rating = json['rating'] as num
    ..reviewer = json['reviewer'] as Map<String, dynamic>
    ..project = json['project'] as Map<String, dynamic>
    ..reviewReceiver = json['reviewReceiver'] as Map<String, dynamic>;
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'reviewId': instance.reviewId,
      'timeCreated': instance.timeCreated,
      'content': instance.content,
      'rating': instance.rating,
      'reviewer': instance.reviewer,
      'project': instance.project,
      'reviewReceiver': instance.reviewReceiver
    };
