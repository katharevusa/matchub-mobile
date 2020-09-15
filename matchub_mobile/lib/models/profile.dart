import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
    Profile();

    num accountId;
    String uuid;
    String email;
    bool accountLocked;
    bool accountExpired;
    bool disabled;
    List roles;
    bool isVerified;
    String joinDate;
    String phoneNumber;
    String country;
    String city;
    String profilePhoto;
    num reputationPoints;
    List followers;
    List following;
    List savedResourceIds;
    List upvotedProjectIds;
    num spotlightChances;
    List posts;
    List notifications;
    List hostedResources;
    List sdgs;
    List meetings;
    List projectsJoined;
    List projectsOwned;
    List joinRequests;
    List reviewsReceived;
    List badges;
    List fundPladges;
    List tasks;
    List managedChannel;
    List joinedChannel;
    List likedPosts;
    String firstName;
    String lastName;
    String genderEnum;
    String profileDescription;
    List projectFollowing;
    List skillSet;
    
    factory Profile.fromJson(Map<String,dynamic> json) => _$ProfileFromJson(json);
    Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
