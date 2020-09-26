import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/profile/profile_projects.dart';
import 'package:matchub_mobile/screens/project/drawerMenu.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:provider/provider.dart';

import '../../style.dart';

class ProjectOverview extends StatefulWidget {
  static const routeName = "/project-screen";
  @override
  _ProjectOverviewState createState() => _ProjectOverviewState();
}

class _ProjectOverviewState extends State<ProjectOverview> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context).myProfile;
    List<Project> allProjects = [];
    allProjects..addAll(myProfile.projectsOwned)..addAll(myProfile.projectsJoined);

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          drawer: DrawerMenu(),
          appBar: AppBar(
            leading: IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                _key.currentState.openDrawer();
              },
            ),
            automaticallyImplyLeading: false,
            leadingWidth: 40,
            title: Text("Projects",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.textMultiplier * 3,
                    fontWeight: FontWeight.w600)),
            backgroundColor: kScaffoldColor,
            elevation: 0,
            bottom: TabBar(
                unselectedLabelColor: Colors.grey[600],
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF68b0ab)),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("All"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Created By Me"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Joined"),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            ProfileProjects(
              projects: allProjects,
              isOwner: true,
            ),
            Icon(Icons.movie),
            Icon(Icons.games),
          ]),
        ),
      ),
    );
  }
}
