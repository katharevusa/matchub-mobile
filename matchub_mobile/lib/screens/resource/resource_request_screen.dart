import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/resource/incomingResourceRequest_screen.dart';
import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/outgoingResourceRequest_screen.dart';

class ResourceRequestScreen extends StatefulWidget {
  static const routeName = "/resource-request-screen";
  @override
  _ResourceRequestScreenState createState() => _ResourceRequestScreenState();
}

class _ResourceRequestScreenState extends State<ResourceRequestScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Resource Requests"),
        backgroundColor: Color.fromRGBO(64, 133, 140, 0.8),
        elevation: 0.0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                tabs: [
                  Tab(text: "Incoming"),
                  Tab(text: "Outgoing"),
                ],
                labelColor: Color.fromRGBO(64, 133, 140, 0.8),
                indicatorColor: Color.fromRGBO(64, 133, 140, 0.8),
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Container(
                    child: IncomingResourceRequest(),
                  ),
                  Container(
                    child: OutgoingResourceRequest(),
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
