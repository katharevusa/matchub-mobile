import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/errorDialog.dart';
import 'package:provider/provider.dart';

class FollowingScreen extends StatefulWidget {
  Profile user;
  Function toggleFollowing;
  Function update;
  FollowingScreen({this.user, this.toggleFollowing, this.update});
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  Future followingFuture;

  List<Profile> following;
  List<Profile> filteredFollowing;
  String searchQuery = "";
  Profile myProfile;

  @override
  void initState() {
    super.initState();
    followingFuture = getFollowers();
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
  }

  getFollowers() async {
    Map<String, dynamic> responseData;
    responseData = await ApiBaseHelper().getProtected(
        "authenticated/getFollowing/${widget.user.accountId}",
        Provider.of<Auth>(context, listen: false).accessToken);
    following = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
        filteredFollowing = following;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
          body: FutureBuilder(
        future: followingFuture,
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        expands: false,
                        decoration: InputDecoration(
                          hintText: "Search Profile...",
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                            filteredFollowing = following
                                .where((element) => element.name
                                    .toUpperCase()
                                    .contains(value.toUpperCase()))
                                .toList();
                          });
                        }),
                  ),
                  SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                    itemBuilder: (context, index) => ListTile(
                      onTap: () => Navigator.of(context).pushNamed(ProfileScreen.routeName, arguments: filteredFollowing[index].accountId),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage(following[index].profilePhoto),
                      ),
                      title: Text(following[index].name),
                      trailing: FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                            (myProfile.following
                                        .indexOf(filteredFollowing[index].accountId) !=
                                    -1)
                                ? "Following"
                                : "Follow",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          int followId = filteredFollowing[index].accountId;
                          widget.toggleFollowing(followId);
                          int followerIndex =
                              myProfile.following.indexOf(followId);
                          Profile removeFollower =
                              filteredFollowing.removeAt(followerIndex);

                          setState(() {
                            myProfile.toggleFollow(followId);
                          });
                          // widget.update();
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            content: Text(
                                "You've stopped following: ${removeFollower.name}"),
                            duration: Duration(seconds: 3),
                            action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  myProfile.toggleFollow(followId);
                                  setState(() {
                                    filteredFollowing.insert(
                                        followerIndex, removeFollower);
                                  });
                                  ApiBaseHelper().postProtected(
                                      "authenticated/followProfile?followId=${followId}&accountId=${myProfile.accountId}",
                                      accessToken:
                                          Provider.of<Auth>(context).accessToken);
                                }),
                          ));
                        },
                        color: (myProfile.following
                                    .indexOf(filteredFollowing[index].accountId) >
                                -1)
                            ? Colors.grey
                            : kAccentColor,
                      ),
                    ),
                    itemCount: filteredFollowing.length,
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
