// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voterCredential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoterCredential _$VoterCredentialFromJson(Map<String, dynamic> json) {
  return VoterCredential()
    ..voterCredentialId = json['voterCredentialId'] as num
    ..voterSecret = json['voterSecret'] as String
    ..isUsed = json['isUsed'] as bool
    ..voter = json['voter'] != null ? Profile.fromJson(json['voter']) : null
    ..competition = json['competition'] != null
        ? Competition.fromJson(json['competition'])
        : null;
}

Map<String, dynamic> _$VoterCredentialToJson(VoterCredential instance) =>
    <String, dynamic>{
      'voterCredentialId': instance.voterCredentialId,
      'voterSecret': instance.voterSecret,
      'isUsed': instance.isUsed,
      'voter': instance.voter,
      'competition': instance.competition
    };
