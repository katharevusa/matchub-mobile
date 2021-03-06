import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/about/projectFollowerList.dart';
import 'package:matchub_mobile/services/manageProject.dart';

import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class PManagementProjectFollowers extends StatefulWidget {
  Project project;
  PManagementProjectFollowers(this.project);

  @override
  _PManagementProjectFollowersState createState() =>
      _PManagementProjectFollowersState();
}

class _PManagementProjectFollowersState
    extends State<PManagementProjectFollowers> {
  @override
  initState() {
    // Provider.of<ManageProject>(context, listen: false)
    //     .getProject(widget.project.projectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.project = Provider.of<ManageProject>(context).managedProject;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.black38,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              settings: RouteSettings(name: "/project-followers"),
              builder: (_) => ProjectFollowerList(
                    project: widget.project,
                  )));
        },
        child: Container(
          height: 190,
          width: 200,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 26,
                ),
                Text("Project", style: TextStyle(color: Colors.grey[700],
                        fontWeight: FontWeight.w400,
                    fontSize: 20,)),
                Text("Followers",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.supervisor_account,
                        size: 30, color: Colors.grey[700]),
                    SizedBox(width: 10),
                    Text(widget.project.projectFollowers.length.toString(),
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey[700],
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                widget.project.projectFollowers.isNotEmpty
                    ? Stack(
                        children: [
                          ...buildProjectFollowers(
                              context, widget.project.projectFollowers),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            "0 Followers...",
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildProjectFollowers(
      BuildContext context, List<TruncatedProfile> projectFollowers) {
    List<Widget> followers = [];
    var l = projectFollowers.length;
    if (projectFollowers.length > 5) {
      projectFollowers = projectFollowers.sublist(0, 5);
    }
    followers.add(Container(
      height: 30,
      width: 180,
      color: Colors.transparent,
      child: Stack(
        children: [
          ...projectFollowers
              .asMap()
              .map(
                (i, e) => MapEntry(
                  i,
                  Transform.translate(
                    offset: Offset(i * 20.0, 0),
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: _buildAvatar(e, radius: 30)),
                  ),
                ),
              )
              .values
              .toList(),
        ],
      ),
    ));
    followers.add(
      Positioned(
        right: 10,
        bottom: 0,
        child: Container(
          height: 10,
          child: l - projectFollowers.length != 0
              ? Text(
                  (l - projectFollowers.length).toString() + ' more...',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 10),
                )
              : Container(),
        ),
      ),
    );
    return followers;
  }

  Widget _buildAvatar(TruncatedProfile e, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: ClipOval(
        child: AttachmentImage(e.profilePhoto),
      ),
    );
  }
}
