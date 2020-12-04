import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/screens/home/components/greetingCard.dart';
import 'package:matchub_mobile/screens/home/components/viewCompetition.dart';
import 'package:matchub_mobile/screens/home/newsfeed.dart';
import 'package:matchub_mobile/screens/search/searchPage.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import 'exploreList.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(child: GreetingCard()),
                    ViewCompetition(),
                  ],
                ),
              ),
              SliverAppBar(
                actions: [
                  IconButton(
                    color: Colors.grey[850],
                    icon: Icon(FlutterIcons.search_fea),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(SearchResults.routeName);
                    },
                  )
                ],
                backgroundColor: kScaffoldColor,
                pinned: true,
                // floating: true,
                // snap: true,
                toolbarHeight: 5.5 * SizeConfig.heightMultiplier,
                centerTitle: true, stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                      left: 4 * SizeConfig.widthMultiplier,
                      right: 4 * SizeConfig.widthMultiplier,
                      bottom: 0.5 * SizeConfig.heightMultiplier),
                  // preferredSize: new Size(
                  //     SizeConfig.widthMultiplier, 6 * SizeConfig.heightMultiplier),
                  title: TabBar(
                    onTap: (_) {
                      _scrollController.animateTo(
                          33 * SizeConfig.heightMultiplier,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.ease);
                    },
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(
                      right: 20,
                    ),
                    tabs: [
                      Text("Feed"),
                      Text("Explore"),
                    ],
                    controller: controller,
                    unselectedLabelStyle: TextStyle(
                      color: Colors.grey[650],
                    ),
                    indicatorColor: kScaffoldColor.withOpacity(0),
                    labelColor: Colors.grey[900],
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 2.7 * SizeConfig.textMultiplier,
                    ),
                    unselectedLabelColor: Colors.grey[400],
                  ),
                ),
              ),
              // SliverFillRemaining(
              //   child: TabBarView(
              //     children: <Widget>[
              //       SliverToBoxAdapter(
              //           child: HomeList(controller: _scrollController)),
              //       SliverToBoxAdapter(child: ExploreList()),
              //     ],
              //     controller: controller,
              //   ),
              // )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              HomeList(),
              ExploreList(),
            ],
            controller: controller,
          ),
        ),
      ),
    );
  }
}
