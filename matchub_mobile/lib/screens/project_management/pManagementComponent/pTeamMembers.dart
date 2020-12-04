import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/teamMemberManagement.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class PManagementTeamMembers extends StatefulWidget {
  Project project;
  PManagementTeamMembers(this.project);

  @override
  _PManagementTeamMembersState createState() => _PManagementTeamMembersState();
}

class _PManagementTeamMembersState extends State<PManagementTeamMembers> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.project =
        Provider.of<ManageProject>(context, listen: false).managedProject;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.black38,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(name: "/team-members"),
              builder: (_) => TeamMembersManagement(
                project: widget.project,
              ),
            ),
          );
        },
        child: Container(
            height: 150,
            width: 250,
            child: (widget.project.projectOwners.indexWhere((element) =>
                        element.accountId ==
                        Provider.of<Auth>(context, listen: false)
                            .myProfile
                            .accountId) !=
                    -1)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Stack(children: <Widget>[
                            Icon(
                              Icons.notifications,
                              size: 30,
                              color: Colors.white,
                            ),
                            buildJoinRequest(widget.project) != 0
                                ? Positioned(
                                    top: -1.0,
                                    right: -1.0,
                                    child: new Stack(children: <Widget>[
                                      new Icon(
                                        Icons.brightness_1,
                                        size: 12.0,
                                        color: AppTheme.project5,
                                      ),
                                    ]))
                                : Container(),
                          ]),
                          Text(' You have ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          Text(
                            buildJoinRequest(widget.project).toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25, 
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text("New Join Requests",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                      SizedBox(
                        height: 10,
                      ),
                      // widget.project.teamMembers.isNotEmpty
                      //     ? Stack(
                      //         children: [
                      //           ...buildProjectMembers(
                      //               context, widget.project.teamMembers),
                      //         ],
                      //       )
                      //     : Text(
                      //         "No Team Members",
                      //         style: TextStyle(fontSize: 12, color: Colors.black),
                      //       )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(' Team members: ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      widget.project.teamMembers.isNotEmpty
                          ? Stack(
                              children: [
                                ...buildProjectMembers(
                                    context, widget.project.teamMembers),
                              ],
                            )
                          : Text(
                              "No Team Members",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            )
                    ],
                  )),
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
          child: l - teamMembers.length != 0
              ? Text(
                  (l - teamMembers.length).toString() + ' more...',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 10),
                )
              : Container(),
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

  num buildJoinRequest(Project project) {
    num counter = 0;
    for (JoinRequest jr in project.joinRequests) {
      if (jr.status == "ON_HOLD") {
        counter++;
      }
    }
    return (counter);
  }
}
