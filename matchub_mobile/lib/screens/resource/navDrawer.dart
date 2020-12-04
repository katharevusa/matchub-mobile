import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/resource/resourceDonationHistoryScreen.dart';
import 'package:matchub_mobile/screens/resource/resourceScreen.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/resourceIncomingScreen.dart';
import 'package:matchub_mobile/screens/resource/resource_outgoing/resourceOutgoingScreen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Resource menu',
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
          ),
          ListTile(
              leading: Icon(Icons.format_list_bulleted),
              title: Text('Resource'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ResourceScreen()));
              }),
          ListTile(
              leading: Icon(Icons.live_help),
              title: Text('Incoming Request'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => IncomingRequestScreen()));
              }),
          ListTile(
              leading: Icon(Icons.live_help),
              title: Text('Outgoing Request'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => OutgoingRequestScreen()));
              }),
          ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Donation history'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ResourceDonationHistoryScreen()));
              }),
        ],
      ),
    );
  }
}
