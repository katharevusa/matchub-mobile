import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/home/components/greetingCard.dart';
import 'package:matchub_mobile/screens/home/exploreList.dart';
import 'package:matchub_mobile/screens/home/newsfeed.dart';
import 'package:matchub_mobile/screens/profile/profileComments.dart';
import 'package:matchub_mobile/screens/profile/profileProjects.dart';
import 'package:matchub_mobile/screens/profile/profileResource.dart';
import 'package:matchub_mobile/screens/profile/profileReviews.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:share/share.dart';

import 'header.dart';

class ViewProfile extends StatefulWidget {
  static const routeName = "/view-profile";
  int accountId;

  ViewProfile({this.accountId});

  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile>
    with SingleTickerProviderStateMixin {
  TabController controller;
  ScrollController _scrollController = ScrollController();
  Profile profile;
  bool isLoading = true;

  @override
  void initState() {
    retrieveUser();
    controller = new TabController(length: 4, vsync: this);
    super.initState();
  }

  retrieveUser() async {
    setState(() {
      isLoading = true;
    });
    var responseData = await ApiBaseHelper.instance
        .getProtected("authenticated/getAccount/${widget.accountId}");
    setState(() {
      profile = Profile.fromJson(responseData);
      isLoading = false;
    });
    print("user loaded");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => retrieveUser(),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: NestedScrollView(
                  // physics: const AlwaysScrollableScrollPhysics(),
                  // controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        toolbarHeight: 50,
                        automaticallyImplyLeading: true,
                        actions: [
                          IconButton(
                              icon: Icon(
                                FlutterIcons.share_faw5s,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                Share.share(
                                    'Hey there! Ever heard of the United Nation\'s Sustainable Development Goals?\nCheck out this profile, he\'s been doing great work!\nhttp://localhost:3000/profile/${profile.uuid}');
                              })
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                            child: ProfileHeader(
                          profile: profile,
                        )),
                      ),
                      SliverAppBar(
                        backgroundColor: kScaffoldColor,
                        pinned: true, elevation: 0,
                        // floating: true,
                        // snap: true,
                        toolbarHeight: 3.0 * SizeConfig.heightMultiplier,
                        bottom: PreferredSize(
                          preferredSize:
                              Size(100 * SizeConfig.widthMultiplier, 25),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: TabBar(
                              labelColor: Colors.grey[850],
                              unselectedLabelColor: Colors.grey[400],
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                  width: 4,
                                  color: kSecondaryColor,
                                ),
                              ),
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.label,
                              controller: controller,
                              tabs: [
                                Tab(
                                  text: ("Activity Feed"),
                                ),
                                Tab(
                                  text: ("Projects"),
                                ),
                                Tab(
                                  text: ("Resources"),
                                ),
                                Tab(
                                  text: ("Reviews"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: <Widget>[
                      ProfileActivity(profile: profile, scrollable: false),
                      ProfileProjects(
                          projects: profile.projectsOwned, scrollable: false),
                      ProfileResource(profile, scrollable: false),
                      ProfileReviews(profile, scrollable: false),
                    ],
                    controller: controller,
                  ),
                ),
              ),
      ),
    );
  }
}
