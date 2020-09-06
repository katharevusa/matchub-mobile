import 'package:flutter/material.dart';

class ResourceScreen extends StatefulWidget {
  static const routeName = "/resource-screen";
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

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