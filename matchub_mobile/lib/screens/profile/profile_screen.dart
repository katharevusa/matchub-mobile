import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/profile/components/basicInfo.dart';
import 'package:matchub_mobile/screens/profile/components/wall.dart';
import 'package:matchub_mobile/screens/profile/profile_projects.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/errorDialog.dart';
import 'package:provider/provider.dart';

import 'components/descriptionInfo.dart';

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
    var responseData = await ApiBaseHelper().getProtected(
        "authenticated/getAccount/${widget.accountId}",
        Provider.of<Auth>(
          context,
        ).accessToken);
    setState(() {
      if(widget.accountId == Provider.of<Auth>(context).myProfile.accountId){
        profile = Provider.of<Auth>(context).myProfile;
      } else{
      profile = Profile.fromJson(responseData);
      }
    });
    print("user loaded");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                  icon: Icon(FlutterIcons.briefcase_fea),
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
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  BasicInfo(profile: profile),
                                  DescriptionInfo(profile: profile),
                                  Wall(profile: profile)
                                ],
                              ))),
                          ProfileProjects(projects: profile.projectsOwned),
                          Container(
                              height: 100,
                              child: Center(child: Text("Sdfsdfs")))
                        ],
                      )
                    : Center(child: CircularProgressIndicator()),
          ),
        ));
  }
}
