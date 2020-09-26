// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truncatedProfile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TruncatedProfile _$TruncatedProfileFromJson(Map<String, dynamic> json) {
  return TruncatedProfile()
    ..accountId = json['accountId'] as num
    ..uuid = json['uuid'] as String
    ..email = json['email'] as String
    ..accountLocked = json['accountLocked'] as bool
    ..accountExpired = json['accountExpired'] as bool
    ..disabled = json['disabled'] as bool
    ..roles = json['roles'] as List
    ..isVerified = json['isVerified'] as bool
    ..joinDate = json['joinDate'] as String
    ..countryCode = json['countryCode'] as String
    ..phoneNumber = json['phoneNumber'] as String
    ..country = json['country'] as String
    ..city = json['city'] as String
    ..profilePhoto = json['profilePhoto'] as String
    ..reputationPoints = json['reputationPoints'] as num
    ..followers = json['followers'] as List
    ..following = json['following'] as List
    ..savedResourceIds = json['savedResourceIds'] as List
    ..upvotedProjectIds = json['upvotedProjectIds'] as List
    ..downvotedProjectIds = json['downvotedProjectIds'] as List
    ..spotlightChances = json['spotlightChances'] as num
    ..posts = json['posts'] as List
    ..notifications = json['notifications'] as List
    ..hostedResources = json['hostedResources'] as List
    ..firstName = json['firstName'] as String
    ..lastName = json['lastName'] as String
    ..genderEnum = json['genderEnum'] as String
    ..profileDescription = json['profileDescription'] as String
    ..projectFollowing = json['projectFollowing'] as List
    ..skillSet = json['skillSet'] as List
    ..name = json['organizationName'] as String ??
        (json['firstName'] + " " + json['lastName']) as String;
}

Map<String, dynamic> _$TruncatedProfileToJson(TruncatedProfile instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'uuid': instance.uuid,
      'email': instance.email,
      'accountLocked': instance.accountLocked,
      'accountExpired': instance.accountExpired,
      'disabled': instance.disabled,
      'roles': instance.roles,
      'isVerified': instance.isVerified,
      'joinDate': instance.joinDate,
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'country': instance.country,
      'city': instance.city,
      'profilePhoto': instance.profilePhoto,
      'reputationPoints': instance.reputationPoints,
      'followers': instance.followers,
      'following': instance.following,
      'savedResourceIds': instance.savedResourceIds,
      'upvotedProjectIds': instance.upvotedProjectIds,
      'downvotedProjectIds': instance.downvotedProjectIds,
      'spotlightChances': instance.spotlightChances,
      'posts': instance.posts,
      'notifications': instance.notifications,
      'hostedResources': instance.hostedResources,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'genderEnum': instance.genderEnum,
      'profileDescription': instance.profileDescription,
      'projectFollowing': instance.projectFollowing,
      'skillSet': instance.skillSet
    };
