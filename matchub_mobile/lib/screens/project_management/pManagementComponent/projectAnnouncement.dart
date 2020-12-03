import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/notification/viewAllNotification.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectChannels.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectFollowers.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectMatchedResources.dart';
import 'package:matchub_mobile/screens/project_management/project_management.dart';
import 'package:matchub_mobile/unused/teamMember.dart';
import 'package:matchub_mobile/sizeConfig.dart';

import 'pProjectFollowers.dart';

class PAnnouncementCard extends StatelessWidget {
  const PAnnouncementCard({
    Key key,
    @required this.publicAnnouncements,
    @required this.internalAnnouncements,
    @required this.widget,
  }) : super(key: key);

  final List<Announcement> publicAnnouncements;
  final List<Announcement> internalAnnouncements;
  final ProjectManagementOverview widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              fit: StackFit.passthrough,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 17 * SizeConfig.heightMultiplier,
                      width: 100 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              colors: [
                            Colors.white,
                            Colors.white,
                          ])),
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 4 * SizeConfig.heightMultiplier,
                            left: 8 * SizeConfig.widthMultiplier),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Latest Project Announcement",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              SizedBox(height: 10),
                              publicAnnouncements.length == 0 &&
                                      internalAnnouncements.length == 0
                                  ? Text("No Announcement...")
                                  : publicAnnouncements.length == 0 &&
                                          internalAnnouncements.length != 0
                                      ? Text(internalAnnouncements[
                                              internalAnnouncements.length - 1]
                                          .title)
                                      : Text(publicAnnouncements[
                                              publicAnnouncements.length - 1]
                                          .title)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        settings: RouteSettings(name: "/notifications"),
                        builder: (_) =>
                            AllNotifications(project: widget.project)));
                  },
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    height: 150,
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      "assets/images/Announcement_pManagement.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 200,
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      "assets/images/plant.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     PManagementTeamMember(widget.project),
            //     Container(
            //       color: Colors.black,
            //       height: 150,
            //       width: 1,
            //     ),
            //     PManagementProjectFollower(widget.project),
            //   ],
            // ),
            // PManagementRecommendedResources(widget.project),
          ]),
        ));
  }
}
