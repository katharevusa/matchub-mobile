import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/unused/project_screen.dart';
import 'package:matchub_mobile/screens/profile/profileScreen.dart';

class ExploreScreen extends StatefulWidget {
  static const routeName = "/explore-screen";
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Color(0xffE70F0B),
                    labelColor: Color(0xffE70F0B),
                    tabs: [
                      Tab(
                        icon: Row(
                          children: [
                            Icon(FlutterIcons.library_books_mco),
                            Text('  All'),
                          ],
                        ),
                      ),
                      Tab(
                        icon: Row(
                          children: [
                            Icon(FlutterIcons.tasks_faw5s),
                            Text('  Projects'),
                          ],
                        ),
                      ),
                      Tab(
                        icon: Row(
                          children: [
                            Icon(FlutterIcons.briefcase_fea),
                            Text('  Resources'),
                          ],
                        ),
                      ),
                      Tab(
                        icon: Row(
                          children: [
                            Icon(FlutterIcons.user_fea),
                            Text('  Users'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Text('Tab 5'),
                      ),
                      Tab(
                        child: Text('Tab 6'),
                      )
                    ]),
                preferredSize: Size.fromHeight(40.0)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.search),
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text('Tab 1'),
                ),
              ),
              // Container(
              //   child: ExploreProjects(),
              // ),
              // Container(
              //   child: ExploreResources(),
              // ),
              Container(
                child: Center(
                  child: Text('Tab 4'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Tab 5'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Tab 6'),
                ),
              ),
            ],
          )),
    );
  }
}
