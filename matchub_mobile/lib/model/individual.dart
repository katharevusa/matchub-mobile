import 'package:flutter/material.dart';
import 'package:matchub_mobile/model/post.dart';
import 'package:matchub_mobile/model/sdg.dart';

class Individual with ChangeNotifier {
  String firstName;
  String lastName;
  String email;
  GenderEnum genderEnum;
  String profileDescription;
  List<int> projectFollowing;
  List<String> skillSet;

  String profilePhoto;
  String profileUrl;
  int reputationPoints;
  List<int> followers;
  List<int> following;
  List<SDG> sdgs;
  
  String country;
  String city;
  List<Post> posts;

  Individual(
      {this.firstName,
      this.lastName,
      this.email,
      this.genderEnum,
      this.profileDescription,
      this.projectFollowing = const [],
      this.skillSet = const [],
      this.sdgs = const [],
      this.posts = const [],
      this.profilePhoto,
      this.reputationPoints,
      this.followers,
      this.following,
      this.country,
      this.city,
      this.profileUrl,
      });
}

enum GenderEnum { MALE, FEMALE }
