import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/wall_components/activities.dart';
import 'package:matchub_mobile/screens/profile/wall_components/createPost.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class Wall extends StatefulWidget {
  Profile profile;
  Wall({this.profile});

  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  Map<String, dynamic> post;
  Post newPost = new Post();
  List<Post> listOfPosts;
  @override
  void initState() {
    post = {
      'postId': newPost.postId,
      'content': newPost.content ?? "",
      'timeCreated': newPost.timeCreated,
      'photos': newPost.photos ?? [],
      'originalPostId': newPost.originalPostId,
      'previousPostId': newPost.previousPostId,
      'postCreatorId': newPost.postCreatorId,
      'likes': newPost.likes,
      'listOfComments': newPost.listOfComments ?? [],
    };
  }

  postFunc(context) async {
    post['postCreatorId'] = Provider.of<Auth>(context).myProfile.accountId;
    final url = "authenticated/createPost";
    var accessToken = Provider.of<Auth>(context).accessToken;
    try {
      final response = await ApiBaseHelper().postProtected(url,
          accessToken: accessToken, body: json.encode(post));
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }

  retrieveAllPosts() async {
    ApiBaseHelper _helper = ApiBaseHelper();
    final url = 'authenticated/getPostsByAccountId/${widget.profile.accountId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    listOfPosts =
        (responseData['content'] as List).map((e) => Post.fromJson(e)).toList();
    listOfPosts = new List.from(listOfPosts.reversed);
    print(listOfPosts[0].content);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController = new TextEditingController();
    textFieldController.text = post['content'];

    return FutureBuilder(
      future: retrieveAllPosts(),
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8 * SizeConfig.widthMultiplier),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Activity", style: AppTheme.titleLight),
                    SizedBox(height: 20),
                    //post new activity here
                    CreatePost(
                        textFieldController, post, postFunc, widget.profile),
                    Activities(listOfPosts, widget.profile),

                    if (listOfPosts.isEmpty) Text("No Posts Yet"),
                    SizedBox(height: 20)
                  ]),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
