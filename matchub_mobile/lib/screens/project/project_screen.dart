import 'package:flutter/material.dart';

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
      )
    );
  }
}