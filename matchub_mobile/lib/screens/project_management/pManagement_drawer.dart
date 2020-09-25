import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/project_screen.dart';

import 'channels/channel_screen.dart';

class ProjectManagementDrawer extends StatelessWidget {
  final Project project;
  ProjectManagementDrawer({this.project});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 40),
        width: 300,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.0),
                SizedBox(height: 30.0),
                _buildRow(Icons.home, "Channels", ChannelsScreen(project:project), context),
                Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
      IconData icon, String title, Widget widget, BuildContext context,
      {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(fontSize: 16.0);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => widget));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(children: [
          SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
          Spacer(),
          if (showBadge)
            Material(
              color: Colors.deepOrange,
              elevation: 5.0,
              shadowColor: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  "10+",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ]),
      ),
    );
  }
}
