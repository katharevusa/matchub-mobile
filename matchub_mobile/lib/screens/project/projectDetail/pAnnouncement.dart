import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pPublicAnnouncements.dart';
import 'package:matchub_mobile/screens/project_management/notification/viewAllNotification.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_notification.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class PAnnouncement extends StatefulWidget {
  Project project;
  PAnnouncement(this.project);
  @override
  _PAnnouncementState createState() => _PAnnouncementState();
}

class _PAnnouncementState extends State<PAnnouncement> {
  List<Announcement> publicAnnouncements = [];
  bool isLoaded;
  Profile profile;
  @override
  void initState() {
    setState(() {
      isLoaded = false;
    });
    loadAnnouncements();
    super.initState();
  }

  loadAnnouncements() async {
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectInternal(widget.project, profile, accessToken);
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectPublic(widget.project, profile, accessToken);
  }

  @override
  Widget build(BuildContext context) {
    profile = Provider.of<Auth>(context, listen: false).myProfile;
    publicAnnouncements =
        Provider.of<ManageNotification>(context).projectPublicAnnouncement;
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppTheme.project4,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                settings: RouteSettings(name: "/pPublicAnnouncements"),
                builder: (_) => PPublicAnnouncements(
                    publicAnnouncements: publicAnnouncements)));
          },
          child: Row(
            children: [
              Icon(FlutterIcons.volume_2_sli, color: AppTheme.project1),
              SizedBox(
                width: 10,
              ),
              publicAnnouncements.length == 0
                  ? Text("No announcement")
                  : Text(publicAnnouncements[0].title),
            ],
          ),
        ),
      ),
    );
  }
}
