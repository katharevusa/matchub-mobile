import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/about/projectAnnouncement.dart';
import 'package:matchub_mobile/screens/project_management/reputationPointAllocation/repAllocation.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/screens/project/projectCreation/projectCreationScreen.dart';
import 'package:matchub_mobile/screens/project_management/about/projectChannels.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectMatchedResources.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/swiperCard.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

import 'pFundCampaign.dart';

class PManagementAbout extends StatefulWidget {
  const PManagementAbout(
      {Key key,
      @required this.myProfile,
      @required this.project,
      @required this.publicAnnouncements,
      @required this.internalAnnouncements,
      @required this.loadProject})
      : super(key: key);
  final Function loadProject;
  final Profile myProfile;
  final List<Announcement> publicAnnouncements;
  final List<Announcement> internalAnnouncements;
  final Project project;

  @override
  _PManagementAboutState createState() => _PManagementAboutState();
}

class _PManagementAboutState extends State<PManagementAbout> {
  projectEndingAction(Project project, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                padding: EdgeInsets.all(10),
                // height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                child: project.projStatus == "ACTIVE"
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FlatButton(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Spotlight Project"),
                                onPressed: () async {
                                  try {
                                    await spotlightProject();
                                  } catch (e) {
                                    showErrorDialog(e.toString(), context);
                                  }
                                  // spotlightAction(project, context);
                                  Navigator.pop(context, true);
                                },
                              ),
                              Divider(),
                              FlatButton(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Terminate Project Early"),
                                onPressed: () async {
                                  await terminateProject();
                                  Navigator.pop(context, true);
                                },
                              ),
                              Divider(),
                              FlatButton(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Mark Project as Complete"),
                                onPressed: () async {
                                  await markProjectAsComplete();
                                  Navigator.pop(context, true);
                                },
                              ),
                            ],
                          )
                        ],
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "This project has already been " +
                                project.projStatus,
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
          ),
        );
      },
    );
  }

  spotlightProject() async {
    final url =
        "authenticated/spotlightProject/${widget.project.projectId}/${widget.myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );
      await widget.loadProject();
      print("Success");
    } catch (error) {
      print("Failure");
      showErrorDialog(error.toString(), context);
    }
  }

  terminateProject() async {
    final url =
        "authenticated/terminateProject?projectId=${widget.project.projectId}&profileId=${widget.myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );

      print("Success");
      await widget.loadProject();
    } catch (error) {
      print("Failure");
      showErrorDialog(error.toString(), context);
    }
  }

  markProjectAsComplete() async {
    final url =
        "authenticated/completeProject?projectId=${widget.project.projectId}&profileId=${widget.myProfile.accountId}";
    try {
      // var accessToken = Provider.of<Auth>(this.context,listen: false).accessToken;
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );
      print("Success");
      await widget.loadProject();
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      PManagementHeader(
          myProfile: widget.myProfile,
          project: widget.project,
          projectEndingAction: projectEndingAction),
      widget.project.projStatus == "COMPLETED"
          ? RepAllocation(widget.project)
          : Container(),
      PManagementSwiperCard(widget.project),
      // PFundCampaignCard(),
      PAnnouncementCard(
        publicAnnouncements: widget.publicAnnouncements,
        internalAnnouncements: widget.internalAnnouncements,
        project: widget.project,
      ),
      PManagementChannels(widget.project),
    ]);
  }
}

class PManagementHeader extends StatefulWidget {
  PManagementHeader({
    Key key,
    @required this.project,
    @required this.myProfile,
    @required this.projectEndingAction,
    @required this.loadProject,
  }) : super(key: key);
  final Project project;
  final Profile myProfile;
  Function loadProject;
  Function projectEndingAction;

  @override
  _PManagementHeaderState createState() => _PManagementHeaderState();
}

class _PManagementHeaderState extends State<PManagementHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              width: 100 * SizeConfig.widthMultiplier,
              height: 70 * SizeConfig.widthMultiplier,
              child: AttachmentImage(widget.project.projectProfilePic))),
      Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          height: 70 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xCC000000),
                const Color(0x70000000),
                const Color(0x70000000),
                const Color(0x70000000),
                const Color(0xCC000000),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                widget.project.projectTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 40),
              Text(
                widget.project.projectDescription,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 8,
        right: 8,
        child: Row(
          children: [
            (widget.myProfile.projectsOwned
                        .indexWhere((e) => e.projectId == widget.project.projectId) >=
                    0)
                ? IconButton(
                    visualDensity: VisualDensity.compact,
                    iconSize: 22,
                    icon: Icon(Icons.create),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) =>
                                ProjectCreationScreen(newProject: widget.project))))
                : Container(),
            IconButton(
                iconSize: 24,
                icon: Icon(Icons.more_vert_rounded),
                color: Colors.white,
                onPressed: () => widget.projectEndingAction(widget.project, context))
          ],
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: Text(
            DateFormat.yMMMd().format(widget.project.startDate) +
                " - " +
                DateFormat.yMMMd().format(widget.project.endDate),
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400)),
      ),
      Positioned(
          bottom: 20,
          left: 20,
          child: !widget.project.spotlight &&
                  widget.project.projStatus != "COMPLETED" &&
                  widget.project.projStatus != "TERMINATED" &&
                  (widget.myProfile.projectsOwned.indexWhere(
                          (e) => e.projectId == widget.project.projectId) >=
                      0)
              ? InkWell(
                  onTap: () {
                    spotlightAction(widget.project, context);
                  },
                  child: Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppTheme.project3,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_border,
                          color: Colors.black,
                        ),
                        Text("Spotlight"),
                      ],
                    ),
                  ),
                )
              : Container())
    ]);
  }

  spotlightAction(Project project, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(15),
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                        "Spotlight your project so that your project will appear on the featured projects on explore.",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FlatButton(
                            color: AppTheme.project3,
                            padding: const EdgeInsets.all(5.0),
                            child: Text("Spotlight project",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                            onPressed: () async {
                              await spotlightProject();
                              Navigator.pop(context, true);
                            },
                          ),
                          Text(
                            '${widget.myProfile.spotlightChances} ' +
                                "chances left.",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.transparent,
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                          image: AssetImage(
                            './././assets/images/spotlight.png',
                          ),
                        ))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  spotlightProject() async {
    final url =
        "authenticated/spotlightProject/${widget.project.projectId}/${widget.myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );
      await widget.loadProject();
      print("Success");
    } catch (error) {
      print("Failure");
      showErrorDialog(error.toString(), this.context);
    }
  }
}
