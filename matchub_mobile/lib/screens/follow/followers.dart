import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/errorDialog.dart';
import 'package:provider/provider.dart';

class FollowersScreen extends StatefulWidget {
  Profile user;
  Function toggleFollowing;
  Function update;
  FollowersScreen({this.user, this.toggleFollowing, this.update});
  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  Future followersFuture;

  List<Profile> followers;
  Profile myProfile;

  @override
  void initState() {
    super.initState();
    followersFuture = getFollowers();
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
  }

  getFollowers() async {
    Map<String, dynamic> responseData;
    responseData = await ApiBaseHelper().getProtected(
        "authenticated/getFollowers/${widget.user.accountId}",
        Provider.of<Auth>(context, listen: false).accessToken);
    followers = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: followersFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Column(
              children: [
                SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 5),
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage(followers[index].profilePhoto),
                    ),
                    title: Text(followers[index].name),
                    trailing: FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                          (myProfile.following
                                      .indexOf(followers[index].accountId) !=
                                  -1)
                              ? "Following"
                              : "Follow",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async{
                        int followId = followers[index].accountId;
                        await widget.toggleFollowing(followId);

                        setState(() {
                          myProfile.toggleFollow(followId);
                        });
                        // print("toggle follo button");
                        // widget.update();
                      },
                      color: (myProfile.following
                                  .indexOf(followers[index].accountId) >
                              -1)
                          ? Colors.grey
                          : kAccentColor,
                    ),
                  ),
                  itemCount: followers.length,
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    ));
  }
}
