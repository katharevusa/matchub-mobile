import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/about/projectFollowerList.dart';

import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class PProgressBar extends StatefulWidget {
  Project project;
  PProgressBar(this.project);

  @override
  _PProgressBarState createState() => _PProgressBarState();
}

class _PProgressBarState extends State<PProgressBar> {
  GlobalKey _toolTipKey = GlobalKey();
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
    int denominator =
        (widget.project.endDate.difference(widget.project.startDate).inDays);
    if (denominator == 0) {
      denominator = 1;
    }
    int progress = (DateTime.now().difference(widget.project.startDate).inDays /
            denominator *
            100)
        .toInt();
    print("progress: " + progress.toString());
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: FAProgressBar(
            //     progressColor: kKanbanColor,
            //     backgroundColor: Colors.grey[200],
            //     size: 6,
            //     animatedDuration: const Duration(milliseconds: 2500),
            //     currentValue: progress,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Icon(Icons.remove_red_eye,
                                  size: 24, color: Colors.grey[700]),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  widget.project.projectFollowers.length
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Text("Followers",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700])),
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

                      await Provider.of<Auth>(context, listen: false)
                          .retrieveUser();
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
                                Icons.thumb_up_alt,
                                size: 24,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Text("Upvotes",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ),
                  // myProfile.reputationPoints >= 50
                  InkWell(
                    onTap: myProfile.reputationPoints >= 50
                        ? () async {
                            if (!myProfile.downvotedProjectIds
                                .contains(widget.project.projectId)) {
                              await ApiBaseHelper.instance.postProtected(
                                  "authenticated/downvoteProject?projectId=${widget.project.projectId}&userId=${myProfile.accountId}");
                            } else {
                              await ApiBaseHelper.instance.postProtected(
                                  "authenticated/revokeDownvote?projectId=${widget.project.projectId}&userId=${myProfile.accountId}");
                            }

                            await Provider.of<Auth>(context, listen: false)
                                .retrieveUser();
                            setState(() {
                              getProjects();
                            });
                          }
                        : () {
                            final dynamic tooltip = _toolTipKey.currentState;
                            tooltip.ensureTooltipVisible();
                          },
                    child: myProfile.reputationPoints >= 50
                        ? Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.thumb_down_alt,
                                      size: 24,
                                      color: myProfile.downvotedProjectIds
                                              .contains(
                                                  widget.project.projectId)
                                          ? kAccentColor
                                          : Colors.grey[300],
                                    ),
                                  ],
                                ),
                                Text("Downvote",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700])),
                              ],
                            ),
                          )
                        : Tooltip(
                            key: _toolTipKey,
                            message: 'You have not unlock this achievement',
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_down_alt,
                                        size: 24,
                                        color: Colors.grey[300],
                                      ),
                                    ],
                                  ),
                                  Text("Downvote",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700])),
                                ],
                              ),
                            )),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.group, size: 24, color: Colors.grey[700]),
                          SizedBox(
                            width: 5,
                          ),
                          Text(widget.project.teamMembers.length.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Text("Team size",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
