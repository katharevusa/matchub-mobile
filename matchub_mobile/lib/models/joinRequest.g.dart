// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joinRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinRequest _$JoinRequestFromJson(Map<String, dynamic> json) {
  return JoinRequest()
    ..joinRequestId = json['joinRequestId'] as num
    ..requestCreationTime = DateTime.parse(json['requestCreationTime'])
    ..status = json['status'] as String
    ..requestor = TruncatedProfile.fromJson(json['requestor'] as Map<String, dynamic>)
    ..project = Project.fromJson(json['project'] as Map<String, dynamic>);
}

Map<String, dynamic> _$JoinRequestToJson(JoinRequest instance) =>
    <String, dynamic>{
      'joinRequestId': instance.joinRequestId,
      'requestCreationTime': instance.requestCreationTime,
      'status': instance.status,
      'requestor': instance.requestor,
      'project': instance.project
    };
