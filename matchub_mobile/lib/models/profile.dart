import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/model/post.dart';
import 'package:matchub_mobile/models/project.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile with ChangeNotifier {
  Profile();

  num accountId;
  String name;
  bool isOrgnisation;
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
  List<Project> projectsOwned;
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

  // factory Profile.fromJson(Map<String,dynamic> json) => _$ProfileFromJson(json);
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile()
      ..accountId = json['accountId'] as num
      ..name = json['organizationName'] as String?? (json['firstName'] +" "+ json['lastName'])as String
      ..isOrgnisation = json['organizationName'] !=null ? true : false
      ..uuid = json['uuid'] as String
      ..email = json['email'] as String
      ..accountLocked = json['accountLocked'] as bool
      ..accountExpired = json['accountExpired'] as bool
      ..disabled = json['disabled'] as bool
      ..roles = json['roles'] as List
      ..isVerified = json['isVerified'] as bool
      ..joinDate = json['joinDate'] as String
      ..phoneNumber = json['phoneNumber'] as String?? "" 
      ..country = json['country'] as String?? "" 
      ..city = json['city']as String ?? "" 
      ..profilePhoto = "assets/images/avatar2.jpg"
      // ..profilePhoto = json['profilePhoto'] as String
      ..reputationPoints = json['reputationPoints'] as num
      ..followers = json['followers'] as List
      ..following = json['following'] as List
      ..savedResourceIds = json['savedResourceIds'] as List
      ..upvotedProjectIds = json['upvotedProjectIds'] as List
      ..spotlightChances = json['spotlightChances'] as num
      ..posts = json['posts'] as List
      ..notifications = json['notifications'] as List
      ..hostedResources = json['hostedResources'] as List
      ..sdgs = json['sdgs'] as List
      ..meetings = json['meetings'] as List
      ..projectsJoined = json['projectsJoined'] as List
      ..projectsOwned = (json['projectsOwned'] as List)
          .map((i) => Project.fromJson(i))
          .toList()
      ..joinRequests = json['joinRequests'] as List
      ..reviewsReceived = json['reviewsReceived'] as List
      ..badges = json['badges'] as List
      ..fundPladges = json['fundPladges'] as List
      ..tasks = json['tasks'] as List
      ..managedChannel = json['managedChannel'] as List
      ..joinedChannel = json['joinedChannel'] as List
      ..likedPosts = json['likedPosts'] as List
      ..firstName = json['firstName'] as String ?? ""
      ..lastName = json['lastName'] as String ?? "" 
      ..genderEnum = json['genderEnum'] as String
      ..profileDescription = json['profileDescription']  ?? json['organizationDescription'] as String
      ..projectFollowing = json['projectFollowing'] as List
      ..skillSet = json['skillSet'] as List ?? json['areasOfExpertise'];
  }
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  void toggleLikedPost(Post post) {
    if (this.likedPosts == null) {
      this.likedPosts = [];
    }
    if (this
            .likedPosts
            .indexWhere((element) => element.postId == post.postId) >=
        0) {
      this.likedPosts.remove(post);
    } else {
      this.likedPosts.add(post);
    }
    notifyListeners();
  }
}
