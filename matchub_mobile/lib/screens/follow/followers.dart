import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/screens/profile/profileScreen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:matchub_mobile/screens/profile/viewProfile.dart';

class FollowersScreen extends StatefulWidget {
  Profile user;
  List<Profile> follow;
  Function toggleFollowing;
  FollowersScreen({this.follow, this.toggleFollowing, this.user});
  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  Future followersFuture;

  List<Profile> followers;
  List<Profile> filteredFollowers;
  Profile myProfile;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    // followersFuture = getFollowers();
    followers = widget.follow;
    filteredFollowers = followers;
  }

  // getFollowers() async {
  //   Map<String, dynamic> responseData;
  //   responseData = await ApiBaseHelper.instance.getProtected(
  //       "authenticated/getFollowers/${widget.user.accountId}",
  //       Provider.of<Auth>(context, listen: false).accessToken);
  //   followers = (responseData['content'] as List)
  //       .map((e) => Profile.fromJson(e))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: Column(
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
                    filteredFollowers = followers
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
            itemBuilder: (context, index) {
              bool isFollowing = (myProfile.following
                      .indexOf(filteredFollowers[index].accountId) >
                  -1);

              return ListTile(
                onTap: () => Navigator.of(context).pushNamed(
                    ViewProfile.routeName,
                    arguments: filteredFollowers[index].accountId),
                leading: ClipOval(
                    child: Container(
                  height: 50,
                  width: 50,
                  child: AttachmentImage(filteredFollowers[index].profilePhoto),
                )),
                title: Text(filteredFollowers[index].name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey[700])),
                trailing: FlatButton(
                  minWidth: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1,
                          color: isFollowing
                              ? Colors.blueGrey[100]
                              : kPrimaryColor),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                      (filteredFollowers[index].accountId ==
                              myProfile.accountId)
                          ? "Myself"
                          : isFollowing
                              ? "Following"
                              : "+ Follow",
                      style: TextStyle(
                        color: (myProfile.following.indexOf(
                                    filteredFollowers[index].accountId) >
                                -1) || (filteredFollowers[index].accountId ==
                              myProfile.accountId)
                            ? Colors.white
                            : kPrimaryColor,
                      )),
                  onPressed: () async {
                    if (filteredFollowers[index].accountId ==
                        myProfile.accountId) return null;

                    int followId = filteredFollowers[index].accountId;
                    await widget.toggleFollowing(followId);

                    setState(() {
                      myProfile.toggleFollow(followId);
                    });
                  },
                  color: (filteredFollowers[index].accountId ==
                          myProfile.accountId)
                      ? kSecondaryColor
                      : isFollowing
                          ? Colors.blueGrey[100]
                          : kScaffoldColor,
                ),
              );
            },
            itemCount: filteredFollowers.length,
          ),
        ],
      )),
    );
  }
}
