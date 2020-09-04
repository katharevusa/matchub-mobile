import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/resource/navDrawer.dart';

class ResourceScreen extends StatefulWidget {
  static const routeName = "/resource-screen";
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Center(child: Text("Resouce")),
        ));
  }
}
