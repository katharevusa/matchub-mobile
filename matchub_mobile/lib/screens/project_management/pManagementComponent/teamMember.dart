import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class PManagementTeamMember extends StatefulWidget {
  Project project;
  PManagementTeamMember(this.project);

  @override
  _PManagementTeamMemberState createState() => _PManagementTeamMemberState();
}

class _PManagementTeamMemberState extends State<PManagementTeamMember> {
  @override
  initState() {
    Provider.of<ManageProject>(context, listen: false).getProject(
        widget.project.projectId,
        Provider.of<Auth>(context, listen: false).accessToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.project = Provider.of<ManageProject>(context).managedProject;
    return Container(
      height: 150,
      width: 180,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Team Members",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Monaco'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              Text(buildJoinRequest(widget.project)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              ...buildProjectMembers(context, widget.project.teamMembers),
            ],
          ),
        ],
      ),
    );
  }

  buildProjectMembers(
      BuildContext context, List<TruncatedProfile> teamMembers) {
    List<Widget> members = [];
    var l = teamMembers.length;
    if (teamMembers.length > 5) {
      teamMembers = teamMembers.sublist(0, 5);
    }
    members.add(Container(
      height: 30,
      width: 180,
      color: Colors.transparent,
      child: Stack(
        children: [
          ...teamMembers
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
    members.add(
      Positioned(
        right: 10,
        bottom: 0,
        child: Container(
          height: 10,
          // alignment: Alignment.centerRight,
          child: Text(
            (l - teamMembers.length).toString() + ' more...',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
          ),
        ),
      ),
    );
    return members;
  }

  Widget _buildAvatar(TruncatedProfile e, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: CircleAvatar(
        radius: radius - 2,
        backgroundImage: NetworkImage(
            "${ApiBaseHelper().baseUrl}${e.profilePhoto.substring(30)}"),
      ),
    );
  }

  String buildJoinRequest(Project project) {
    num counter = 0;
    for (JoinRequest jr in project.joinRequests) {
      if (jr.status == "ON_HOLD") {
        counter++;
      }
    }
    return (counter.toString() + ' New Join Requests');
  }
}
