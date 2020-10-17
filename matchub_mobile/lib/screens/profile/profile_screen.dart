import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/models/profile.dart';

import 'package:matchub_mobile/screens/profile/profile_projects.dart';
import 'package:matchub_mobile/screens/profile/profile_resource.dart';
import 'package:matchub_mobile/screens/profile/profile_reviews.dart';
import 'package:matchub_mobile/screens/profile/wall_components/basicInfo.dart';
import 'package:matchub_mobile/screens/profile/wall_components/descriptionInfo.dart';
import 'package:matchub_mobile/screens/profile/wall_components/wall.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile-screen";
  int accountId;

  ProfileScreen({this.accountId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future loadUser;
  Profile profile;
  @override
  void didChangeDependencies() {
    loadUser = getUser();
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  getUser() async {
    var responseData = await ApiBaseHelper.instance.getProtected(
        "authenticated/getAccount/${widget.accountId}",
         accessToken:Provider.of<Auth>(
          context,
        ).accessToken);
    setState(() {
      // if (widget.accountId == Provider.of<Auth>(context).myProfile.accountId) {
      //   profile = Provider.of<Auth>(context).myProfile;
      // } else {
      profile = Profile.fromJson(responseData);
      // }
    });
    print("user loaded");
  }

  toggleFollowing(int followId) async {
    Profile myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    try {
      var responseData;
      if (myProfile.following.indexOf(followId) != -1) {
        responseData = await ApiBaseHelper.instance.postProtected(
            "authenticated/unfollowProfile?unfollowId=${followId}&accountId=${myProfile.accountId}",
            accessToken: Provider.of<Auth>(context).accessToken);
      } else {
        responseData = await ApiBaseHelper.instance.postProtected(
            "authenticated/followProfile?followId=${followId}&accountId=${myProfile.accountId}",
            accessToken: Provider.of<Auth>(context).accessToken);
      }
      getUser();
      await loadUser;
      setState(() {});
    } catch (error) {
      print(error.toString());
      showErrorDialog(error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(FlutterIcons.user_fea),
                ),
                Tab(
                  icon: Icon(FlutterIcons.tasks_faw5s),
                ),
                Tab(
                  icon: Icon(FlutterIcons.lightbulb_outline_mco),
                ),
                Tab(
                  icon: Icon(FlutterIcons.rate_review_mdi),
                ),
              ],
            ),
          ),
          body: FutureBuilder(
            future: loadUser,
            builder: (context, snapshot) =>
                (snapshot.connectionState == ConnectionState.done)
                    ? TabBarView(
                        children: [
                          RefreshIndicator(
                              onRefresh: () => getUser(),
                              child: GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    BasicInfo(
                                        profile: profile,
                                        follow: toggleFollowing),
                                    DescriptionInfo(profile: profile),
                                    Wall(profile: profile,)
                                  ],
                                )),
                              )),
                          ProfileProjects(projects: profile.projectsOwned),
                          ProfileResource(profile),
                          ProfileReviews(),
                        ],
                      )
                    : Center(child: CircularProgressIndicator()),
          ),
        ));
  }
}
