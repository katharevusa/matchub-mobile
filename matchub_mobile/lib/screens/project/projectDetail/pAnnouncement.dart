import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pPublicAnnouncements.dart';
import 'package:matchub_mobile/screens/project_management/notification/viewAllNotification.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_notification.dart';
import 'package:matchub_mobile/sizeConfig.dart';
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
        padding: EdgeInsets.only(
            top: 1.5 * SizeConfig.heightMultiplier,
            right: 8.0 * SizeConfig.widthMultiplier,
            left: 8.0 * SizeConfig.widthMultiplier),
        child: Text(
          "ANNOUNCEMENTS",
          style: TextStyle(
              color: Colors.grey[600], fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
        Container(
          margin: const EdgeInsets.all(15.0),
          padding:EdgeInsets.only(
            top: 1.5 * SizeConfig.heightMultiplier,
            right: 8.0 * SizeConfig.widthMultiplier,
            left: 8.0 * SizeConfig.widthMultiplier),
          child: InkWell(
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
      ],
    );
  }
}
