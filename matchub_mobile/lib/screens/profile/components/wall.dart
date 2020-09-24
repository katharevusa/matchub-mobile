import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/components/activities.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/errorDialog.dart';
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

  _post(context) async {
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
    var profileId = Provider.of<Auth>(context).myProfile.accountId;
    final url = 'authenticated/getPostsByAccountId/${profileId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    listOfPosts =
        (responseData['content'] as List).map((e) => Post.fromJson(e)).toList();
    listOfPosts = new List.from(listOfPosts.reversed);
    print(listOfPosts[0].content);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _textFieldController = new TextEditingController();
    _textFieldController.text = post['content'];
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
                    TextFormField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        labelText: 'Write a post',
                        hintText: 'What do you want to talk about?',
                        labelStyle:
                            TextStyle(color: Colors.grey[850], fontSize: 14),
                        fillColor: Colors.grey[100],
                        hoverColor: Colors.grey[100],
                        suffix: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            _post(context);
                            _textFieldController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kSecondaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[850],
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 500,
                      maxLengthEnforced: true,
                      onChanged: (text) {
                        post["content"] = text;
                        print(post["content"]);
                      },
                    ),
                    Activities(listOfPosts, widget.profile),

                    if (listOfPosts.isEmpty) Text("No Posts Yet"),
                    SizedBox(height: 20)
                  ]),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
