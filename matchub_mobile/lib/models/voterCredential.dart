import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'voterCredential.g.dart';

@JsonSerializable()
class VoterCredential {
  VoterCredential();

  num voterCredentialId;
  String voterSecret;
  bool isUsed;
  Profile voter;
  Competition competition;

  factory VoterCredential.fromJson(Map<String, dynamic> json) =>
      _$VoterCredentialFromJson(json);
  Map<String, dynamic> toJson() => _$VoterCredentialToJson(this);
}
