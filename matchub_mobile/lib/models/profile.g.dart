part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..accountId = json['accountId'] as num
    ..name = json['organizationName'] as String ??
        (json['firstName'] + " " + json['lastName']) as String
    ..isOrganisation = json['organizationName'] != null ? true : false
    ..verificationDocuments =
        json['verificationDocuments'] as Map<String, dynamic>
    ..employees = json['employees'] as List
    ..uuid = json['uuid'] as String
    ..email = json['email'] as String
    ..accountLocked = json['accountLocked'] as bool
    ..accountExpired = json['accountExpired'] as bool
    ..disabled = json['disabled'] as bool
    ..roles = json['roles'] as List
    ..isVerified = json['isVerified'] as bool
    ..joinDate = json['joinDate'] as String
    ..phoneNumber = json['phoneNumber'] as String ?? ""
    ..countryCode = json['countryCode'] as String ?? ""
    ..country = json['country'] as String ?? ""
    ..city = json['city'] as String ?? ""
    ..address = json['address'] as String ?? ""
    // ..profilePhoto = "assets/images/avatar2.jpg"
    ..profilePhoto = json['profilePhoto'] ?? ""
    ..reputationPoints = json['reputationPoints'] as num
    ..followers = json['followers'] as List
    ..following = json['following'] as List
    ..savedResourceIds = json['savedResourceIds'] as List
    ..upvotedProjectIds = json['upvotedProjectIds'] as List
    ..spotlightChances = json['spotlightChances'] as num
    ..posts = json['posts'] as List
    ..notifications = json['notifications'] as List
    ..hostedResources = json['hostedResources'] as List
    ..sdgs = (json['sdgs'] as List).map((i) => Sdg.fromJson(i)).toList()
    ..meetings = json['meetings'] as List
    ..projectsJoined = (json['projectsJoined'] as List)
        .map((i) => Project.fromJson(i))
        .toList()
    ..projectsOwned =
        (json['projectsOwned'] as List).map((i) => Project.fromJson(i)).toList()
    ..joinRequests = json['joinRequests'] as List
    ..reviewsReceived = json['reviewsReceived'] as List
    ..badges = (json['badges'] as List).map((i) => Badge.fromJson(i)).toList()
    ..fundPladges = json['fundPladges'] as List
    ..tasks = json['tasks'] as List
    ..managedChannel = json['managedChannel'] as List 
    ..joinedChannel = json['joinedChannel'] as List
    ..likedPosts = json['likedPosts'] as List
    ..firstName = json['firstName'] as String ?? ""
    ..lastName = json['lastName'] as String ?? ""
    ..genderEnum = json['genderEnum'] as String
    ..profileDescription =
        json['profileDescription'] ?? json['organizationDescription'] as String
    ..projectFollowing = json['projectFollowing'] as List
    ..skillSet = json['skillSet'] as List ?? json['areasOfExpertise'] as List;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'uuid': instance.uuid,
      'email': instance.email,
      'accountLocked': instance.accountLocked,
      'accountExpired': instance.accountExpired,
      'disabled': instance.disabled,
      'roles': instance.roles,
      'isVerified': instance.isVerified,
      'joinDate': instance.joinDate,
      'phoneNumber': instance.phoneNumber,
      'country': instance.country,
      'city': instance.city,
      'profilePhoto': instance.profilePhoto,
      'reputationPoints': instance.reputationPoints,
      'followers': instance.followers,
      'following': instance.following,
      'savedResourceIds': instance.savedResourceIds,
      'upvotedProjectIds': instance.upvotedProjectIds,
      'spotlightChances': instance.spotlightChances,
      'posts': instance.posts,
      'notifications': instance.notifications,
      'hostedResources': instance.hostedResources,
      'sdgs': instance.sdgs,
      'meetings': instance.meetings,
      'projectsJoined': instance.projectsJoined,
      'projectsOwned': instance.projectsOwned,
      'joinRequests': instance.joinRequests,
      'reviewsReceived': instance.reviewsReceived,
      'badges': instance.badges,
      'fundPladges': instance.fundPladges,
      'tasks': instance.tasks,
      'managedChannel': instance.managedChannel,
      'joinedChannel': instance.joinedChannel,
      'likedPosts': instance.likedPosts,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'genderEnum': instance.genderEnum,
      'profileDescription': instance.profileDescription,
      'projectFollowing': instance.projectFollowing,
      'skillSet': instance.skillSet
    };
