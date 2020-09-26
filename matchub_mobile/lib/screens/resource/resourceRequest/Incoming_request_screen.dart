import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';

class IncomingRequestScreen extends StatefulWidget {
  static const routeName = "/resource-request-screen";
  @override
  _IncomingRequestScreenState createState() => _IncomingRequestScreenState();
}

class _IncomingRequestScreenState extends State<IncomingRequestScreen>
    with SingleTickerProviderStateMixin {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          drawer: ResourceDrawer(),
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
                            Text('  Pending'),
                          ],
                        ),
                      ),
                      Tab(
                        icon: Row(
                          children: [
                            Icon(FlutterIcons.tasks_faw5s),
                            Text('  Approved'),
                          ],
                        ),
                      ),
                      Tab(
                        icon: Row(
                          children: [
                            Icon(FlutterIcons.briefcase_fea),
                            Text('  Rejected'),
                          ],
                        ),
                      ),
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
              Container(
                child: Center(
                  child: Text('Tab 1'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Tab 1'),
                ),
              ),
            ],
          )),
    );
  }
}
