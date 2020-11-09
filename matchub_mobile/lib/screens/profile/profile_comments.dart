import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/chat_screen.dart';
import 'package:matchub_mobile/screens/home/components/post_card.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/screens/search/resources_search.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileActivity extends StatefulWidget {
  Profile profile;
  bool scrollable;

  ProfileActivity({this.profile, this.scrollable = true});

  @override
  _ProfileActivityState createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {
  List<Post> listOfPosts = [];
  Future listOfPostsFuture;
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  bool fetchingPosts = true;
  List<Profile> recommendedProfiles = [];
  Profile myProfile;

  @override
  void initState() {
    listOfPostsFuture = retrievePosts();
    super.initState();
  }

  retrievePosts() async {
    final responseData = await ApiBaseHelper.instance
        .getProtected("authenticated/getPostsByAccountId/${widget.profile.accountId}");
    listOfPosts =
        (responseData['content'] as List).map((e) => Post.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // print(listOfResources.length.toString() + "========================");
    return FutureBuilder(
      future: listOfPostsFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? (listOfPosts.isEmpty)
              ? Center(
                  child: Text("No Posts Available", style: AppTheme.titleLight))
              : ListView.builder(
                  physics: widget.scrollable
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => PostCard(
                    post: listOfPosts[index],
                  ),
                  itemCount: listOfPosts.length,
                )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) => Shimmer.fromColors(
                  highlightColor: Colors.white,
                  baseColor: Colors.grey[300],
                  child: ChatListLoader(),
                  period: Duration(milliseconds: 800),
                ),
              ),
            ),
    );
  }
}
