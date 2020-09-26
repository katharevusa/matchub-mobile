import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';

class Badge extends StatefulWidget {
  Map<String, dynamic> project;
  Badge(this.project);

  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  @override
  Widget build(BuildContext context) {
    return Text("hello");
  }
}
