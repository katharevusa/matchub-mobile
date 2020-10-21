// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resourceRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceRequest _$ResourceRequestFromJson(Map<String, dynamic> json) {
  return ResourceRequest()
    ..requestId = json['requestId'] as num
    ..requestCreationTime = DateTime.parse(json['requestCreationTime'])
    ..status = json['status'] as String
    ..requestorId = json['requestorId'] as num
    ..requestorEnum = json['requestorEnum'] as String
    ..resourceId = json['resourceId'] as num
    ..projectId = json['projectId'] as num
    ..unitsRequired = json['unitsRequired'] as num
    ..message = json['message'] as String;
}

Map<String, dynamic> _$ResourceRequestToJson(ResourceRequest instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'requestCreationTime': instance.requestCreationTime,
      'status': instance.status,
      'requestorId': instance.requestorId,
      'requestorEnum': instance.requestorEnum,
      'resourceId': instance.resourceId,
      'projectId': instance.projectId,
      'unitsRequired': instance.unitsRequired,
      'message': instance.message
    };
