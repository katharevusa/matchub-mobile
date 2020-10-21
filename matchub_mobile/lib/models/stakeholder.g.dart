// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stakeholder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stakeholder _$StakeholderFromJson(Map<String, dynamic> json) {
  return Stakeholder()
    ..accountId = json['accountId'] as num
    ..uuid = json['uuid'] as String
    ..email = json['email'] as String
    ..accountLocked = json['accountLocked'] as bool
    ..accountExpired = json['accountExpired'] as bool
    ..disabled = json['disabled'] as bool
    ..roles = json['roles'] as List;
}

Map<String, dynamic> _$StakeholderToJson(Stakeholder instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'uuid': instance.uuid,
      'email': instance.email,
      'accountLocked': instance.accountLocked,
      'accountExpired': instance.accountExpired,
      'disabled': instance.disabled,
      'roles': instance.roles
    };
