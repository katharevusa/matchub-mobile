import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
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
    allProjects
      ..addAll(myProfile.projectsOwned)
      ..addAll(myProfile.projectsJoined);

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          drawer: DrawerMenu(),
          endDrawer: DrawerMenu(),
          appBar: AppBar(
            leading: IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: Image.asset("assets/icons/menu.png"),
              onPressed: () {
                _key.currentState.openDrawer();
              },
            ),
            actions: [IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: Image.asset("assets/icons/menu.png"),
              onPressed: () {
                _key.currentState.openEndDrawer();
              },
            )],
            automaticallyImplyLeading: false,
            // leadingWidth: 40,
            
            title: Text("Projects",
                style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: SizeConfig.textMultiplier * 3,
                    fontWeight: FontWeight.w700)),
            backgroundColor: kScaffoldColor,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: TabBar(
                    labelColor: Colors.grey[600],
                    // isScrollable: true,
                    // indicatorSize: TabBarIndicatorSize.tab,
                    // indicator: new BubbleTabIndicator(
                    //     indicatorRadius: (40),
                    //     indicatorHeight: 25.0,
                    //     indicatorColor: kSecondaryColor,
                    //     tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    //     padding: EdgeInsets.all(10)),
                    unselectedLabelColor: Colors.grey[400],
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 4,
                          color: kSecondaryColor,
                          // color: Color(0xFF646464),
                        ),
                        insets: EdgeInsets.only(left: 8, right: 8, bottom: 4)),
                    isScrollable: true,
                    // labelPadding: EdgeInsets.only(left: 0, right: 0),
                    // indicatorSize: TabBarIndicatorSize.label,
                    // indicator: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(50),
                    //     color: Color(0xFF68b0ab)),
                    tabs: [
                      Tab(
                        text: ("All"),
                      ),
                      Tab(
                        text: ("Created By Me"),
                      ),
                      Tab(
                        text: ("Joined"),
                      ),
                    ]),
              ),
            ),
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
