import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/drawerMenu.dart';
import 'package:matchub_mobile/screens/project/project_management_screen.dart';
import 'package:matchub_mobile/screens/project_management/notification/viewAllNotification.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/swiperCard.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/teamMember.dart';
import 'package:matchub_mobile/screens/project_management/pManagement_drawer.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_notification.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
  List<Announcement> internalAnnouncements = [];
  List<Announcement> publicAnnouncements = [];

  AnimationController _animationController;
  bool isLoaded;

  @override
  void initState() {
    setState(() {
      isLoaded = false;
    });

    loadAnnouncements();
    loadProject();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  loadAnnouncements() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectInternal(widget.project, profile, accessToken);
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectPublic(widget.project, profile, accessToken);
  }

  loadProject() async {
    await Provider.of<ManageProject>(context, listen: false).getProject(
        widget.project.projectId,
        Provider.of<Auth>(context, listen: false).accessToken);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    publicAnnouncements =
        Provider.of<ManageNotification>(context).projectPublicAnnouncement;
    internalAnnouncements =
        Provider.of<ManageNotification>(context).projectInternalAnnouncement;
    return Consumer<ManageProject>(
        builder: (context, project, child) => Scaffold(
              drawer: ProjectManagementDrawer(project: project.managedProject),
              appBar: AppBar(
                backgroundColor: kScaffoldColor,
                elevation: 0,
                leadingWidth: 35,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: isLoaded
                  ? SafeArea(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  project.managedProject.projectTitle,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  project.managedProject.projectDescription,
                                  style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.create,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              PManagementSwiperCard(widget.project),
                            ]),
                          ),
                          SliverAppBar(
                            title: Text("Project management",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300)),
                            backgroundColor: kScaffoldColor,
                            pinned: true,
                          ),
                          SliverFillRemaining(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(60.0)),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(children: <Widget>[
                                    Stack(
                                      overflow: Overflow.visible,
                                      fit: StackFit.passthrough,
                                      children: [
                                        InkWell(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 4 *
                                                    SizeConfig.widthMultiplier),
                                            height: 17 *
                                                SizeConfig.heightMultiplier,
                                            width: 100 *
                                                SizeConfig.widthMultiplier,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomRight,
                                                    end: Alignment.topLeft,
                                                    colors: [
                                                      Color(0xFFFFE1C6),
                                                      Color(0xFFFFF7AE),
                                                    ])),
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 4 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  left: 8 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    50, 0, 20, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        "Latest Project Announcement",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15)),
                                                    SizedBox(height: 10),
                                                    publicAnnouncements
                                                                    .length ==
                                                                0 &&
                                                            internalAnnouncements
                                                                    .length ==
                                                                0
                                                        ? Text(
                                                            "No Announcement")
                                                        : publicAnnouncements
                                                                        .length ==
                                                                    0 &&
                                                                internalAnnouncements
                                                                        .length !=
                                                                    0
                                                            ? Text(internalAnnouncements[
                                                                    internalAnnouncements
                                                                            .length -
                                                                        1]
                                                                .title)
                                                            : Text(publicAnnouncements[
                                                                    publicAnnouncements
                                                                            .length -
                                                                        1]
                                                                .title)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    settings: RouteSettings(
                                                        name: "/notifications"),
                                                    builder: (_) =>
                                                        AllNotifications(
                                                            project: widget
                                                                .project)));
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
                                    //members and followers
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        PManagementTeamMember(widget.project),
                                        PManagementTeamMember(widget.project),
                                        // Container(
                                        //   child: Column(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: [
                                        //       Text("Team members"),
                                        //       RaisedButton(
                                        //         child: Text("View Join Request",
                                        //             style: TextStyle(
                                        //                 fontWeight:
                                        //                     FontWeight.w900,
                                        //                 color: Colors.black,
                                        //                 fontSize: 12)),
                                        //         onPressed: () {
                                        //           // Navigator.pop(context);
                                        //         },
                                        //         shape: RoundedRectangleBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     20.0)),
                                        //       ),
                                        //       PManagementTeamMember(
                                        //           widget.project),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ]),
                                )),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ));
  }
}
