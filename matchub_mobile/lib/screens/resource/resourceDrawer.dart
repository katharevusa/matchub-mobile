import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
// import 'package:matchub_mobile/screens/project/oval-right-clipper.dart';
import 'package:matchub_mobile/unused/project_management_screen.dart';
import 'package:matchub_mobile/unused/project_screen.dart';
import 'package:matchub_mobile/screens/resource/resourceDonationHistoryScreen.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/resourceIncomingScreen.dart';
import 'package:matchub_mobile/screens/resource/resource_outgoing/resourceOutgoingScreen.dart';
import 'package:matchub_mobile/screens/resource/resourceScreen.dart';
import 'package:matchub_mobile/widgets/ovalRightClipper.dart';
import 'package:path/path.dart';

class ResourceDrawer extends StatelessWidget {
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5.0),
                  SizedBox(height: 30.0),
                  _buildRow(Icons.home, "Resource", ResourceScreen(), context),
                  _buildDivider(),
                  _buildRow(Icons.calendar_today, "Incoming Request",
                      IncomingRequestScreen(), context),
                  _buildDivider(),
                  _buildRow(Icons.calendar_today, "Outgoing Request",
                      OutgoingRequestScreen(), context),
                  _buildDivider(),
                  _buildRow(
                    Icons.track_changes,
                    "Resource payment history",
                    ResourceDonationHistoryScreen(),
                    context,
                  ),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(
      IconData icon, String title, Widget widget, BuildContext context,
      {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => widget));
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
