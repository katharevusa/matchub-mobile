import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/chat_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/feed.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../sizeconfig.dart';
import 'components/create_post.dart';
import 'components/post_card.dart';
import 'components/suggested_profile.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  bool fetchingPosts = true;
  List<Post> followingPosts;
  List<Profile> recommendedProfiles = [];
  Profile myProfile;

  @override
  void initState() {
    retrievePosts();
    // TODO: implement initState
    super.initState();
  }

  retrievePosts() async {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    await Provider.of<Feed>(context, listen: false)
        .retrievePosts(myProfile.accountId);
    await Provider.of<Feed>(context, listen: false)
        .retrieveSuggestedProfiles(myProfile.accountId);
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      fetchingPosts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    followingPosts = Provider.of<Feed>(context).followingPosts;
    recommendedProfiles = Provider.of<Feed>(context).recommendedProfiles;

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          buildCreatePost(context),
          buildRecommendedProfiles(),
          buildPosts()
        ],
      ),
    );
    // return buildPosts();
  }

  buildRecommendedProfiles() {
    return recommendedProfiles.isNotEmpty ? SuggestedProfile() : Container();
  }

  Widget buildPosts() {
    return fetchingPosts
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) => Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: PostListLoader(),
                period: Duration(milliseconds: 800),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: followingPosts.length,
            itemBuilder: (_, index) {
              return PostCard(
                post: followingPosts[index],
              );
            },
          );
  }

  Padding buildCreatePost(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => CreatePostScreen(), fullscreenDialog: true),
          );
        },
        child: Container(
          width: 100 * SizeConfig.widthMultiplier,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey[200].withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              color: Colors.white),
          child: Center(
              child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text("What's on your mind...",
                      style: TextStyle(color: Colors.grey[400], fontSize: 14))),
              Icon(FlutterIcons.edit_faw5, color: Colors.grey[400]),
              SizedBox(
                width: 10,
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class PostListLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 200;
    double containerHeight = 15;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    height: containerHeight,
                    width: containerWidth,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: containerHeight,
                    width: containerWidth - 50,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
            ),
            width: 90 * SizeConfig.widthMultiplier,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
