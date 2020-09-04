import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/resource/navDrawer.dart';

class ResourceRequestScreen extends StatefulWidget {
  static const routeName = "/resource-request-screen";
  @override
  _ResourceRequestScreenState createState() => _ResourceRequestScreenState();
}

class _ResourceRequestScreenState extends State<ResourceRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Center(child: Text("Resouce request")),
        ));
  }
}
