import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';

class ProjectScreen extends StatefulWidget {
  static const routeName = "/project-screen";
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(child: Text("Projects")),
      ),
    );
  }
}