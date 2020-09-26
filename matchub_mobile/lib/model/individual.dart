import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/post.dart';

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
  List<int> followers = [];
  List<int> following = [];
  List<Sdg> sdgs = [];

  String country;
  String city;
  List<Post> posts = [];
  List<Post> likedPosts = [];
  // List<Comment> comments = [];

  Individual({
    this.firstName,
    this.lastName,
    this.email,
    this.genderEnum,
    this.profileDescription,
    this.projectFollowing,
    this.skillSet,
    this.sdgs,
    this.posts,
    this.likedPosts,
    this.profilePhoto,
    this.reputationPoints,
    this.followers,
    this.following,
    this.country,
    this.city,
    this.profileUrl,
    // this.comments
  });

  void addPostToWall(Post post) {
    // if (stall.isFavourite) {
    //   _helper.postProtected(
    //       "authenticated/addOrRemoveFavourite?userId=$userId&companyId=${stall.stallId}&addFavourite=true",
    //       accessToken: accessToken);
    //   addToFavourites(stall);
    // } else {
    //   _helper
    this.posts.add(post);
    notifyListeners();
  }

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

enum GenderEnum { MALE, FEMALE }
