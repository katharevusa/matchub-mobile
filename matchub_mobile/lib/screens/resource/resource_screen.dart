import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/screens/resource/expiredResource.dart';
// import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/ongoingResource.dart';
import 'package:matchub_mobile/screens/resource/resource_drawer.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_resource.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:provider/provider.dart';

import '../../style.dart';

class ResourceScreen extends StatefulWidget {
  static const routeName = "/resource-screen";

  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<Resources> listOfResources = [];
  Future resourcesFuture;
  Resources resources;
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  bool _isLoading;

  void selectOwnResource(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/own-resource-detail-screen');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          drawer: ResourceDrawer(),
          appBar: AppBar(
            leadingWidth: 35,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Resources",
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
                        text: ("My Resources"),
                      ),
                      Tab(
                        text: ("Saved Resources"),
                      ),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            Container(
              child: OngoingResource(),
            ),
            // Container(
            //   child: ExpiredResource(listOfResources),
            // ),
            Container(
              child: OngoingResource(),
            ),
          ]),
        ),
      ),
      //   )
      // : Center(child: CircularProgressIndicator()),
    );
  }
}
