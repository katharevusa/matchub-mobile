import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/campaign/campaign_creation.dart';
import 'package:matchub_mobile/screens/home/components/create_post.dart';
import 'package:matchub_mobile/screens/profile/profile_projects.dart';
import 'package:matchub_mobile/unused/drawerMenu.dart';
import 'package:matchub_mobile/screens/project/projectCreation/project_creation_screen.dart';
import 'package:matchub_mobile/screens/project_management/project_management.dart';
import 'package:matchub_mobile/unused/teamMember.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../../../style.dart';

class ProjectOverview extends StatefulWidget {
  static const routeName = "/project-screen";
  @override
  _ProjectOverviewState createState() => _ProjectOverviewState();
}

class _ProjectOverviewState extends State<ProjectOverview> {
  List<Project> allProjects = [];
  bool dialVisible = true;
  final newProject = new Project();
  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context).myProfile;
    allProjects
      ..addAll(myProfile.projectsOwned)
      ..addAll(myProfile.projectsJoined);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("My Projects",
            style: TextStyle(
                color: Colors.grey[850],
                fontSize: SizeConfig.textMultiplier * 3,
                fontWeight: FontWeight.w700)),
        backgroundColor: kScaffoldColor,
        elevation: 0,
      ),
      body: TopScreen(myProfile),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: buildSpeedDial(),
      // floatingActionButton:

      // FlatButton.icon(
      //     color: kAccentColor,
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //     onPressed: () => Navigator.of(context, rootNavigator: true).push(
      //           MaterialPageRoute(
      //               builder: (context) =>
      //                   ProjectCreationScreen(newProject: newProject)),
      //         ),
      //     icon: Icon(Icons.add),
      //     label: Text(
      //       "Create",
      //     ),),
    );
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(backgroundColor: Colors.black87,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0, color: Colors.white),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(FlutterIcons.rocket_faw5s, color: Colors.white, size: 16),
          backgroundColor: kKanbanColor,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) =>
                        ProjectCreationScreen(newProject: newProject)),
              ),
          label: 'Create a project',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.grey[300],
        ),
        SpeedDialChild(
          child: Icon(Icons.campaign_rounded, color: Colors.white),
          backgroundColor: kKanbanColor,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) =>
                        CampaignCreationScreen()),
              ),
          label: 'Launch a fundraiser',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.grey[300],
        ),
        SpeedDialChild(
          child: Icon(FlutterIcons.briefcase_fea, size: 20, color: Colors.white),
          backgroundColor: kKanbanColor,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) =>
                        CampaignCreationScreen()),
              ),
          label: 'List a resource',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.grey[300],
        ),
        SpeedDialChild(
          child: Icon(Icons.edit, color: Colors.white),
          backgroundColor: kKanbanColor,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context,) =>
                        CreatePostScreen()),
              ),
          label: 'Write a Post',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.grey[300],
        ),
      ],
    );
  }
}

class TopScreen extends StatefulWidget {
  Profile myProfile;
  TopScreen(this.myProfile);

  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  bool isOwnProjects = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(countActiveProject().toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      )),
                                  const SizedBox(height: 5.0),
                                  Text("Active projects",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: Colors.grey.shade600,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(countPendingProject().toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      )),
                                  const SizedBox(height: 5.0),
                                  Text("Pending projects",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: Colors.grey.shade600,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      widget.myProfile.projectsOwned
                                          .where((p) =>
                                              p.projStatus == "COMPLETED")
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      )),
                                  const SizedBox(height: 5.0),
                                  Text("Completed projects",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: Colors.grey.shade600,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              setState(() {
                                isOwnProjects = true;
                              });
                            },
                            child: ChoiceChip(
                                "Created Projects - ${widget.myProfile.projectsOwned.length.toString()}",
                                isOwnProjects)),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                isOwnProjects = false;
                              });
                            },
                            child: ChoiceChip(
                                "Joined Projects - ${widget.myProfile.projectsJoined.length.toString()}",
                                !isOwnProjects)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          BottomScreen(widget.myProfile, isOwnProjects),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  num countPendingProject() {
    num counter = 0;
    for (Project p in widget.myProfile.projectsOwned) {
      if (p.projStatus == "ON_HOLD") {
        counter++;
      }
    }
    return counter;
  }

  num countActiveProject() {
    num counter = 0;
    for (Project p in widget.myProfile.projectsOwned) {
      if (p.projStatus == "ACTIVE") {
        counter++;
      }
    }
    return counter;
  }
}

class BottomScreen extends StatelessWidget {
  Profile myProfile;
  bool isflightSelected;
  BottomScreen(this.myProfile, this.isflightSelected);
  List<Widget> members = [
    SizedBox(height: 20),
  ];
  @override
  Widget build(BuildContext context) {
    return isflightSelected
        ? ProjectDashboard(projects: myProfile.projectsOwned)
        : ProjectDashboard(projects: myProfile.projectsJoined);
  }
}

class ProjectDashboard extends StatelessWidget {
  ProjectDashboard({
    Key key,
    @required this.projects,
  }) : super(key: key);

  final List<Project> projects;

  List<Color> colors = <Color>[
    Color(0xffFFFFFF),
    Color(0xffFFE4CB),
    Color(0xffBAF3D3),
    Color(0xffFFD3E3),
    Color(0xffEAE7FC),
    Color(0xffFFF0D3),
  ];
  List<Color> progress = <Color>[
    Color(0xff2AC8FF),
    Color(0xffFF723A),
    Color(0xff00D050),
    Color(0xffFE71AC),
    Color(0xffC6A4FF),
    Color(0xffFEEE97),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 519.0,
        width: 100 * SizeConfig.widthMultiplier,
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10),
            itemCount: projects.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: 1.1,
                mainAxisSpacing: 10),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: colors[index % 6],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 0.5,
                            spreadRadius: 1),
                      ],
                    ),
                    // alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              DateFormat.yMMMMd()
                                  .format(projects[index].startDate),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 9),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          constraints: BoxConstraints(minHeight: 40),
                          child: Text(
                            projects[index].projectTitle,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Progress", style: TextStyle(fontSize: 9)),
                              Text(
                                  "${projects[index].startDate.isAfter(DateTime.now()) ? 0 : DateTime.now().isAfter(projects[index].endDate) ? 100 : (DateTime.now().difference(projects[index].startDate).inDays / (projects[index].endDate.difference(projects[index].startDate).inDays.toDouble()) * 100).round().toString()}%",
                                  style: TextStyle(fontSize: 9))
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        FAProgressBar(
                          progressColor: progress[index % 6],
                          size: 5,
                          animatedDuration: const Duration(milliseconds: 2500),
                          currentValue: projects[index]
                                  .startDate
                                  .isAfter(DateTime.now())
                              ? 0
                              : DateTime.now().isAfter(projects[index].endDate)
                                  ? 100
                                  : (DateTime.now()
                                              .difference(
                                                  projects[index].startDate)
                                              .inDays /
                                          (projects[index]
                                              .endDate
                                              .difference(
                                                  projects[index].startDate)
                                              .inDays
                                              .toDouble()) *
                                          100)
                                      .round(),
                        ),
                        Expanded(child: Divider()),
                        Row(
                          children: [
                            // PManagementTeamMember(
                            //     myProfile.projectsOwned[index]),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                color: index % 6 == 0
                                    ? Color(0xffDCF6FC)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                  child: (projects[index].projStatus ==
                                          "ACTIVE")
                                      ? Text(
                                          (projects[index].endDate)
                                                  .difference(DateTime.now())
                                                  .inDays
                                                  .toString() +
                                              ' Days Left',
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: progress[index % 6]),
                                        )
                                      : projects[index].projStatus ==
                                              "COMPLETED"
                                          ? Text(
                                              'Completed',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: progress[index % 6]),
                                            )
                                          : Text(
                                              'Terminated',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: progress[index % 6]),
                                            )),
                            ),
                          ],
                        )
                      ],
                    )),
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(ProjectManagementOverview.routeName,
                      arguments: projects[index]);
                },
              );
            }));
  }
}

class ChoiceChip extends StatefulWidget {
  final String text;
  final bool isflightSelected;
  ChoiceChip(this.text, this.isflightSelected);
  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: widget.isflightSelected
            ? BoxDecoration(
                color: Colors.black.withOpacity(.15),
                borderRadius: BorderRadius.all(Radius.circular(20)))
            : null,
        child: Text(widget.text,
            style: TextStyle(color: Colors.black, fontSize: 14)));
  }
}
