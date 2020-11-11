import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectAnnouncement.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/unused/drawerMenu.dart';
import 'package:matchub_mobile/screens/project/projectCreation/project_creation_screen.dart';
import 'package:matchub_mobile/unused/project_management_screen.dart';
import 'package:matchub_mobile/screens/project_management/notification/viewAllNotification.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectChannels.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectMatchedResources.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectFollowers.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/swiperCard.dart';
import 'package:matchub_mobile/unused/teamMember.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_notification.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

import 'pManagementComponent/pFundCampaign.dart';

class ProjectManagementOverview extends StatefulWidget {
  static const routeName = "/project-management";
  Project project;

  ProjectManagementOverview(this.project);

  @override
  _ProjectManagementOverviewState createState() =>
      _ProjectManagementOverviewState();
}

class _ProjectManagementOverviewState extends State<ProjectManagementOverview>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Duration _duration = Duration(seconds: 1000000);
  List<Announcement> internalAnnouncements = [];
  List<Announcement> publicAnnouncements = [];
  bool isLoaded;
  Profile myProfile;
  @override
  void initState() {
    setState(() {
      isLoaded = false;
    });
    loadProject();
    loadAnnouncements();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadAnnouncements() async {
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectInternal(widget.project, myProfile, accessToken);
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectPublic(widget.project, myProfile, accessToken);
  }

  loadProject() async {
    await Provider.of<ManageProject>(context, listen: false).getProject(
      widget.project.projectId,
    );
    setState(() {
      isLoaded = true;
    });
  }

  spotlightDuration(Project project, BuildContext context) {
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
                    child: Text("Spotlight will end in",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                  SlideCountdownClock(
                    duration: Duration(
                        days: DateTime.parse(widget.project.spotlightEndTime)
                            .difference(DateTime.now())
                            .inDays,
                        minutes: DateTime.parse(widget.project.spotlightEndTime)
                            .difference(DateTime.now())
                            .inMinutes),
                    slideDirection: SlideDirection.Up,
                    separator: ":",
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shouldShowDays: true,
                    onDone: () {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Spotlight has ended')));
                    },
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
            ),
          ),
        );
      },
    );
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
                  // myProfile.spotlightChances != 0
                  // ?

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
                            '${myProfile.spotlightChances} ' + "chances left.",
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

                  // : Text("You do not have any spotlight chances.")
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Expanded(
                  child: project.projStatus == "ACTIVE"
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
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
          ),
        );
      },
    );
  }

  spotlightProject() async {
    final url =
        "authenticated/spotlightProject/${widget.project.projectId}/${myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );
      await loadProject();
      print("Success");
    } catch (error) {
      print("Failure");
      showErrorDialog(error.toString(), this.context);
    }
  }

  terminateProject() async {
    final url =
        "authenticated/terminateProject?projectId=${widget.project.projectId}&profileId=${myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );

      print("Success");
      await loadProject();
    } catch (error) {
      print("Failure");
      showErrorDialog(error.toString(), this.context);
    }
  }

  markProjectAsComplete() async {
    final url =
        "authenticated/completeProject?projectId=${widget.project.projectId}&profileId=${myProfile.accountId}";
    try {
      // var accessToken = Provider.of<Auth>(this.context,listen: false).accessToken;
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );
      print("Success");
      await loadProject();
      // Navigator.of(this.context).pop("Completed-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    publicAnnouncements =
        Provider.of<ManageNotification>(context).projectPublicAnnouncement;
    internalAnnouncements =
        Provider.of<ManageNotification>(context).projectInternalAnnouncement;
    widget.project = Provider.of<ManageProject>(context).managedProject;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoaded
            ? SingleChildScrollView(
                child: Column(children: <Widget>[
                  PManagementHeader(myProfile : myProfile, project: widget.project, projectEndingAction: projectEndingAction),
                  PManagementSwiperCard(widget.project),
                  PFundCampaignCard(),
                  PAnnouncementCard(publicAnnouncements: publicAnnouncements, internalAnnouncements: internalAnnouncements, widget: widget,),
                  PManagementChannels(widget.project),
                  PManagementMatchedResources(widget.project),
                ]),
              )
            : Container(),
      ),
    );
  }
}

class PManagementHeader extends StatelessWidget {
  PManagementHeader({
    Key key,
    @required this.project,
    @required this.myProfile,
    @required this.projectEndingAction,
  }) : super(key: key);
  final Project project;
  final Profile myProfile;
  Function projectEndingAction;

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
              child: AttachmentImage(project.projectProfilePic))),
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
                project.projectTitle,
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
                project.projectDescription,
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
            (myProfile.projectsOwned
                        .indexWhere((e) => e.projectId == project.projectId) >=
                    0)
                ? IconButton(
                    visualDensity: VisualDensity.compact,
                    iconSize: 22,
                    icon: Icon(Icons.create),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) =>
                                ProjectCreationScreen(newProject: project))))
                : Container(),
            IconButton(
                iconSize: 24,
                icon: Icon(Icons.more_vert_rounded),
                color: Colors.white,
                onPressed: () => projectEndingAction(project, context))
          ],
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: Text(
            DateFormat.yMMMd().format(project.startDate) +
                " - " +
                DateFormat.yMMMd().format(project.endDate),
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400)),
      )
    ]);
  }
}
