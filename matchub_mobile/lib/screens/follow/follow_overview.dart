import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/follow/followers.dart';
import 'package:matchub_mobile/screens/follow/following.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class FollowOverviewScreen extends StatefulWidget {
  static const routeName = "/following-screen";
  Profile user;
  int initialTab;
  FollowOverviewScreen({this.user, this.initialTab});
  @override
  _FollowOverviewScreenState createState() => _FollowOverviewScreenState();
}

class _FollowOverviewScreenState extends State<FollowOverviewScreen>
    with TickerProviderStateMixin {
  Future followersFuture;

  List<Profile> followers;
  List<Profile> following;
  Profile myProfile;

  TabController _controller;
  int _currentIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void dismissSnackBar() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(vsync: this, length: 2, initialIndex: widget.initialTab);
    _controller.addListener(_handleTabSelection);
    followersFuture = getFollowers();
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _controller.index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  toggleFollowing(int followId) async {
    try {
      var responseData;
      setState(() {
        if (myProfile.following.indexOf(followId) != -1) {
          responseData = ApiBaseHelper().postProtected(
              "authenticated/unfollowProfile?unfollowId=${followId}&accountId=${myProfile.accountId}",
              accessToken: Provider.of<Auth>(context).accessToken);
        } else {
          responseData = ApiBaseHelper().postProtected(
              "authenticated/followProfile?followId=${followId}&accountId=${myProfile.accountId}",
              accessToken: Provider.of<Auth>(context).accessToken);
        }
        getFollowers();
      });
      // print("backend method" + widget.user.following.length.toString());
    } catch (error) {
      print(error.toString());
      showErrorDialog(error.toString(), context);
    }
  }

  getFollowers() async {
    Map<String, dynamic> responseData;
    responseData = await ApiBaseHelper().getProtected(
        "authenticated/getFollowers/${widget.user.accountId}",
        Provider.of<Auth>(context, listen: false).accessToken);
    followers = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
    responseData = await ApiBaseHelper().getProtected(
        "authenticated/getFollowing/${widget.user.accountId}",
        Provider.of<Auth>(context, listen: false).accessToken);
    following = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
    // print("Followers length" + following.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // automaticallyImplyLeading: true,
          title: Text("${widget.user.name}"),
          bottom: TabBar(
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: Text("${widget.user.followers.length} Followers"),
              ),
              Tab(
                child: Text("${widget.user.following.length} Following"),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: followersFuture,
          builder: (context, snapshot) =>
              (snapshot.connectionState == ConnectionState.done)
                  ? TabBarView(controller: _controller, children: [
                      if (myProfile.accountId != widget.user.accountId) ...[
                        FollowersScreen(
                            follow: followers,
                            user: widget.user,
                            toggleFollowing: toggleFollowing),
                        FollowersScreen(
                            follow: following,
                            user: widget.user,
                            toggleFollowing: toggleFollowing),
                      ],
                      if (myProfile.accountId == widget.user.accountId) ...[
                        FollowersScreen(
                            follow: followers,
                            user: widget.user,
                            toggleFollowing: toggleFollowing),
                        FollowingScreen(
                            follow: following,
                            user: widget.user,
                            toggleFollowing: toggleFollowing),
                      ]
                    ])
                  : Center(child: CircularProgressIndicator()),
        ));
  }

  Widget followWidget(List<Profile> list, bool followersTab) {
    return Column(
      children: [
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 5),
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(list[index].profilePhoto),
            ),
            title: Text(list[index].name),
            trailing: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              child: Text(
                  (myProfile.following.indexOf(list[index].accountId) != -1)
                      ? "Following"
                      : "Follow",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                int followId = list[index].accountId;
                toggleFollowing(followId);
                int followerIndex = myProfile.following.indexOf(followId);
                Profile removeFollower = following.removeAt(followerIndex);

                setState(() {
                  myProfile.toggleFollow(followId);
                });
                Scaffold.of(context).showSnackBar(new SnackBar(
                  key: UniqueKey(),
                  content:
                      Text("You've stopped following: ${removeFollower.name}"),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        myProfile.toggleFollow(followId);
                        setState(() {
                          if (followerIndex < followers.length - 1) {
                            following.insert(followerIndex, removeFollower);
                          } else {
                            following.add(removeFollower);
                          }
                        });
                        ApiBaseHelper().postProtected(
                            "authenticated/followProfile?followId=${followId}&accountId=${myProfile.accountId}",
                            accessToken:
                                Provider.of<Auth>(context).accessToken);
                      }),
                ));
              },
              color: (myProfile.following.indexOf(list[index].accountId) > -1)
                  ? Colors.grey
                  : kAccentColor,
            ),
          ),
          itemCount: list.length,
        ),
      ],
    );
  }
}
