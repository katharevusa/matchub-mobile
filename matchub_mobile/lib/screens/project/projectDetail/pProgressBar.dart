import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectFollowerList.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class PProgressBar extends StatefulWidget {
  Project project;
  PProgressBar(this.project);

  @override
  _PProgressBarState createState() => _PProgressBarState();
}

class _PProgressBarState extends State<PProgressBar> {
  Profile myProfile;
  getProjects() async {
    await Provider.of<ManageProject>(this.context, listen: false).getProject(
      widget.project.projectId,
    );
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;
    // project = Provider.of<ManageProject>(context).managedProject;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: FAProgressBar(
            progressColor: AppTheme.project1,
            backgroundColor: Colors.grey.withOpacity(0.7),
            size: 6,
            animatedDuration: const Duration(milliseconds: 2500),
            currentValue: 80,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: RouteSettings(name: "/project-followers"),
                    builder: (_) => ProjectFollowerList(
                          project: widget.project,
                        )));
              },
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget.project.projectFollowers.length.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Text("Follower",
                        style: TextStyle(
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (!myProfile.upvotedProjectIds
                    .contains(widget.project.projectId)) {
                  await ApiBaseHelper.instance.postProtected(
                      "authenticated/upvoteProject?projectId=${widget.project.projectId}&userId=${myProfile.accountId}");
                } else {
                  await ApiBaseHelper.instance.postProtected(
                      "authenticated/revokeUpvote?projectId=${widget.project.projectId}&userId=${myProfile.accountId}");
                }

                await Provider.of<Auth>(context, listen: false).retrieveUser();
                setState(() {
                  getProjects();
                });
              },
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.volunteer_activism,
                          size: 30,
                          color: myProfile.upvotedProjectIds
                                  .contains(widget.project.projectId)
                              ? kAccentColor
                              : Colors.grey[300],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget.project.upvotes.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Text("Upvotes",
                        style: TextStyle(
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.group, size: 30),
                    SizedBox(
                      width: 5,
                    ),
                    Text(widget.project.teamMembers.length.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ],
                ),
                Text("Team size",
                    style: TextStyle(
                      fontSize: 12,
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
