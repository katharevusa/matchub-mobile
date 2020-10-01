import 'package:json_annotation/json_annotation.dart';

part 'truncatedProfile.g.dart';

@JsonSerializable()
class TruncatedProfile {
  TruncatedProfile();

  num accountId;
  String uuid;
  String name;
  String email;
  bool accountLocked;
  bool accountExpired;
  bool disabled;
  List roles;
  bool isVerified;
  String joinDate;
  String countryCode;
  String phoneNumber;
  String country;
  String city;
  String profilePhoto;
  num reputationPoints;
  List followers;
  List following;
  List savedResourceIds;
  List upvotedProjectIds;
  List downvotedProjectIds;
  num spotlightChances;
  List posts;
  List notifications;
  List hostedResources;
  String firstName;
  String lastName;
  String genderEnum;
  String profileDescription;
  List projectFollowing;
  List skillSet;

  factory TruncatedProfile.fromJson(Map<String, dynamic> json) =>
      _$TruncatedProfileFromJson(json);
  Map<String, dynamic> toJson() => _$TruncatedProfileToJson(this);
}
