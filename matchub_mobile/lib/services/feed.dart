import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class Feed with ChangeNotifier {
  List<Post> followingPosts;
  List<Profile> recommendedProfiles = [];
  Post post;

  retrievePost(int postId) async {
    post = Post.fromJson(await ApiBaseHelper.instance
        .getProtected("authenticated/getPost/$postId"));
  }
  
  retrievePosts(int accountId) async {
    followingPosts = List.from(await ApiBaseHelper.instance.getWODecode(
            "authenticated/getFollowingUserPosts?userId=$accountId"))
        .map((e) => Post.fromJson(e))
        .toList();
  }

  retrieveSuggestedProfiles(int accountId) async {

    final responseData = await ApiBaseHelper.instance.getProtected(
      "authenticated/recommendProfiles/$accountId",
    );

    recommendedProfiles = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }
}
