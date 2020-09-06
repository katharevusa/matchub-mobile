import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:matchub_mobile/model/resource.dart';
import 'package:matchub_mobile/screens/resource/expiredResource.dart';
import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/ongoingResource.dart';

class ResourceScreen extends StatefulWidget {
  static const routeName = "/resource-screen";

=======

class ResourceScreen extends StatefulWidget {
  static const routeName = "/resource-screen";
>>>>>>> 7f799bf8e20060b9120dd80c752ffecfe0d7cc08
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

<<<<<<< HEAD
class _ResourceScreenState extends State<ResourceScreen>
    with SingleTickerProviderStateMixin {
  void selectOwnResource(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/own-resource-detail-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Resource Overview"),
        backgroundColor: Color.fromRGBO(64, 133, 140, 0.8),
        elevation: 0.0,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                tabs: [
                  Tab(text: "Ongoing"),
                  Tab(text: "Expired"),
                  Tab(text: "Saved"),
                ],
                labelColor: Color.fromRGBO(64, 133, 140, 0.8),
                indicatorColor: Color.fromRGBO(64, 133, 140, 0.8),
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Container(
                    child: OngoingResource(),
                  ),
                  Container(
                    child: ExpiredResource(),
                  ),
                  Container(
                    child: ExpiredResource(),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
=======
class _ResourceScreenState extends State<ResourceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(child: Text("Resources")),
      ),
    );
  }
}
>>>>>>> 7f799bf8e20060b9120dd80c752ffecfe0d7cc08
