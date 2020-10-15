import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/screens/explore/explore_projects.dart';
import 'package:matchub_mobile/screens/explore/explore_resources.dart';
import 'package:matchub_mobile/screens/inbox/inbox-chat.dart';
import 'package:matchub_mobile/screens/inbox/inbox-notification.dart';
import 'package:matchub_mobile/screens/project/project_screen.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';

import '../../sizeconfig.dart';
import '../../style.dart';

class InboxScreen extends StatefulWidget {
  static const routeName = "/explore-screen";
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            leadingWidth: 35,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Inbox",
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
                    unselectedLabelColor: Colors.grey[400],
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 4,
                          color: kSecondaryColor,
                        ),
                        insets: EdgeInsets.only(left: 8, right: 8, bottom: 4)),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: ("Chat"),
                      ),
                      Tab(
                        text: ("Notification"),
                      ),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            Container(
              child: InboxChat(),
            ),
            // Container(
            //   child: ExpiredResource(listOfResources),
            // ),
            Container(
              child: InboxNotification(),
            ),
          ]),
        ),
      ),
      //   )
      // : Center(child: CircularProgressIndicator()),
    );
  }
}
