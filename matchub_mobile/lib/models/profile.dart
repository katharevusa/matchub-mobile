import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile with ChangeNotifier {
  Profile();

  num accountId;
  String uuid;
  String email;
  String name;
  bool stripeAccountChargesEnabled;
  String stripeAccountUid;
  List employees;
  String countryCode;
  String address;
  bool isOrganisation;
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
  List downvotedProjectIds;
  num spotlightChances;
  List posts;
  List notifications;
  List hostedResources;
  List sdgs;
  List meetings;
  List<Project> projectsJoined;
  List<Project> projectsOwned;
  List joinRequests;
  List reviewsReceived;
  List<Badge> badges;
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
  Map<String, dynamic> announcementsSetting;
  Map<String, dynamic> verificationDocuments;
  List<Survey> surveys;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  void toggleFollow(int accountId) {
    if (this.following.indexOf(accountId) > -1) {
      this.following.remove(accountId);
    } else {
      this.following.add(accountId);
      print(this.following.length);
    }
    notifyListeners();
  }
}
