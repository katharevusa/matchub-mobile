import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/home/leaderboard&achievement/achievement.dart';
import 'package:matchub_mobile/screens/home/leaderboard&achievement/individualLeaderboard.dart';
import 'package:matchub_mobile/screens/home/leaderboard&achievement/organisationLeaderboard.dart';

import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';

class Award extends StatefulWidget {
  @override
  _AwardState createState() => _AwardState();
}

class _AwardState extends State<Award> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          // backgroundColor: Colors.transparent,
          key: _key,
          appBar: AppBar(
            leadingWidth: 35,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Container(
                color: Colors.transparent,
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
                        text: ("Individual Leaderboard"),
                      ),
                      Tab(
                        text: ("Organisation Leaderboard"),
                      ),
                      Tab(
                        text: ("Achievement"),
                      ),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            Container(
              child: IndividialLeaderboard(),
            ),
            Container(
              child: OrganisationLeaderboard(),
            ),
            Container(
              child: Achievement(),
            ),
          ]),
        ),
      ),
      //   )
      // : Center(child: CircularProgressIndicator()),
    );
  }
}
