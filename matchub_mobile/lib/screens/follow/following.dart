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
  List<Profile> follow;
  FollowingScreen({this.user, this.toggleFollowing, this.follow});
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
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 5),
                        itemBuilder: (context, index) => ListTile(
                          onTap: () => Navigator.of(context).pushNamed(
                              ProfileScreen.routeName,
                              arguments: filteredFollowing[index].accountId),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage(following[index].profilePhoto),
                          ),
                          title: Text(filteredFollowing[index].name),
                          trailing: FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                                (filteredFollowing[index].accountId ==
                                        myProfile.accountId)
                                    ? "Myself"
                                    : (myProfile.following.indexOf(
                                                filteredFollowing[index]
                                                    .accountId) !=
                                            -1)
                                        ? "Following"
                                        : "Follow",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (filteredFollowing[index].accountId ==
                                  myProfile.accountId) return null;
                              // int followId = filteredFollowing[index].accountId;
                              // await widget.toggleFollowing(followId);

                              // setState(() {
                              //   myProfile.toggleFollow(followId);
                              // });

                              // for person specific
                              int followId = filteredFollowing[index].accountId;
                              widget
                                  .toggleFollowing(followId); //backend api call
                              int followerIndex = following
                                  .indexWhere((p) => p.accountId == followId);
                              Profile removeFollower =
                                  following.removeAt(followerIndex);

                              myProfile.toggleFollow(followId);
                              setState(() {
                                filteredFollowing = following
                                    .where((element) => element.name
                                        .toUpperCase()
                                        .contains(searchQuery.toUpperCase()))
                                    .toList();
                              });
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                content: Text(
                                    "You've stopped following: ${removeFollower.name}"),
                                duration: Duration(seconds: 3),
                                action: SnackBarAction(
                                    label: "Undo",
                                    onPressed: () {
                                      following.insert(
                                          followerIndex, removeFollower);
                                      widget.toggleFollowing(followId);
                                      myProfile.toggleFollow(followId);
                                      
                                      setState(() {
                                        filteredFollowing = following
                                            .where((element) => element.name
                                                .toUpperCase()
                                                .contains(
                                                    searchQuery.toUpperCase()))
                                            .toList();
                                      });
                                    }),
                              ));
                            },
                            color: (myProfile.following.indexOf(
                                        filteredFollowing[index].accountId) >
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
        ));
  }
}
