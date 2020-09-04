import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/screens/home/home_screen.dart';
import 'package:matchub_mobile/screens/project/project_screen.dart';

class ExploreScreen extends StatefulWidget {
  static const routeName = "/explore-screen";
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(child: Text("Explore")),
      ),
      floatingActionButton: FlatButton.icon(
          onPressed: () => ApiBaseHelper().post("createUser", body: ""),
          icon: Icon(Icons.add),
          label: Text("projects")),
    );
  }
}
