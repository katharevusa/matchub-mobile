import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/profile/profile_projects.dart';
import 'package:matchub_mobile/unused/drawerMenu.dart';
import 'package:matchub_mobile/screens/project/projectCreation/project_creation_screen.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/project_management.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/teamMember.dart';
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
  final newProject = new Project();
  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context).myProfile;
    allProjects
      ..addAll(myProfile.projectsOwned)
      ..addAll(myProfile.projectsJoined);
    return Scaffold(
      body: TopScreen(myProfile),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FlatButton.icon(
          onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) =>
                        ProjectCreationScreen(newProject: newProject)),
              ),
          icon: Icon(Icons.add),
          label: Text("Create project")),
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
    return Column(
      children: [
        Stack(
          children: <Widget>[
            Container(
              height: 210,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 16,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(countActiveProject().toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  )),
                              const SizedBox(height: 5.0),
                              Text("Active project",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.grey.shade600,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(countPendingProject().toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  )),
                              const SizedBox(height: 5.0),
                              Text("Pending project",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.grey.shade600,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  widget.myProfile.projectsOwned.length
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  )),
                              const SizedBox(height: 5.0),
                              Text("Owned project",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.grey.shade600,
                                  ))
                            ],
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
                          child: ChoiceChip("My Projects", isOwnProjects)),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              isOwnProjects = false;
                            });
                          },
                          child: ChoiceChip("Joined Projects", !isOwnProjects)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        BottomScreen(widget.myProfile, isOwnProjects)
      ],
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
  Profile myProfile;
  bool isflightSelected;
  BottomScreen(this.myProfile, this.isflightSelected);
  List<Widget> members = [
    SizedBox(height: 20),
  ];
  @override
  Widget build(BuildContext context) {
    return isflightSelected
        ? Container(
            height: 519.0,
            child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: myProfile.projectsOwned.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    child: new Container(
                        decoration: BoxDecoration(
                          color: colors[index % 6],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 0.5,
                            ),
                          ],
                        ),
                        // alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  "     " +
                                      DateFormat('MMMM').format(myProfile
                                          .projectsOwned[index].startDate) +
                                      ' ${myProfile.projectsOwned[index].startDate.day}, ${myProfile.projectsOwned[index].startDate.year}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey.shade600, fontSize: 9),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                myProfile.projectsOwned[index].projectTitle,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("     Progress",
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FAProgressBar(
                                progressColor: progress[index % 6],
                                size: 5,
                                animatedDuration:
                                    const Duration(milliseconds: 2500),
                                currentValue: myProfile
                                        .projectsOwned[index].startDate
                                        .isAfter(DateTime.now())
                                    ? 0
                                    : DateTime.now().isAfter(myProfile
                                            .projectsOwned[index].endDate)
                                        ? 100
                                        : (DateTime.now()
                                                    .difference(myProfile
                                                        .projectsOwned[index]
                                                        .startDate)
                                                    .inDays /
                                                (myProfile.projectsOwned[index]
                                                    .endDate
                                                    .difference(myProfile
                                                        .projectsOwned[index]
                                                        .startDate)
                                                    .inDays
                                                    .toDouble()) *
                                                100)
                                            .round(),
                              ),
                            ),
                            Divider(),
                            Row(
                              children: [
                                // PManagementTeamMember(
                                //     myProfile.projectsOwned[index]),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: 30,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: index % 6 == 0
                                        ? Color(0xffDCF6FC)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                      child: (myProfile.projectsOwned[index]
                                                  .projStatus ==
                                              "ACTIVE")
                                          ? Text(
                                              (myProfile.projectsOwned[index]
                                                          .endDate)
                                                      .difference(
                                                          DateTime.now())
                                                      .inDays
                                                      .toString() +
                                                  ' Days Left',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: progress[index % 6]),
                                            )
                                          : myProfile.projectsOwned[index]
                                                      .projStatus ==
                                                  "COMPLETED"
                                              ? Text(
                                                  'Completed',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color:
                                                          progress[index % 6]),
                                                )
                                              : Text(
                                                  'Terminated',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color:
                                                          progress[index % 6]),
                                                )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )
                          ],
                        )),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(ProjectManagementOverview.routeName,
                          arguments: myProfile.projectsOwned[index]);
                    },
                  );
                }))
        : Container(
            height: 519.0,
            child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: myProfile.projectsJoined.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    child: new Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 0.5,
                            ),
                          ],
                          color: colors[index % 6],
                        ),
                        // alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  "     " +
                                      DateFormat('MMMM').format(myProfile
                                          .projectsJoined[index].startDate) +
                                      ' ${myProfile.projectsJoined[index].startDate.day}, ${myProfile.projectsJoined[index].startDate.year}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey.shade600, fontSize: 9),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                myProfile.projectsJoined[index].projectTitle,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("     Progress",
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FAProgressBar(
                                progressColor: progress[index % 6],
                                size: 5,
                                animatedDuration:
                                    const Duration(milliseconds: 2500),
                                currentValue: myProfile
                                        .projectsJoined[index].startDate
                                        .isAfter(DateTime.now())
                                    ? 0
                                    : DateTime.now().isAfter(myProfile
                                            .projectsJoined[index].endDate)
                                        ? 100
                                        : (DateTime.now()
                                                .difference(myProfile
                                                    .projectsJoined[index]
                                                    .startDate)
                                                .inDays /
                                            (myProfile
                                                .projectsJoined[index].endDate
                                                .difference(myProfile
                                                    .projectsJoined[index]
                                                    .startDate)
                                                .inDays
                                                .toDouble()) *
                                            100),
                                // displayText: '%',
                              ),
                            ),
                            Divider(),
                            Row(
                              children: [
                                // PManagementTeamMember(
                                //     myProfile.projectsJoined[index]),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: 30,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: index % 6 == 0
                                        ? Color(0xffDCF6FC)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                      child: (myProfile.projectsJoined[index]
                                                  .projStatus ==
                                              "ACTIVE")
                                          ? Text(
                                              (myProfile.projectsJoined[index]
                                                          .endDate)
                                                      .difference(
                                                          DateTime.now())
                                                      .inDays
                                                      .toString() +
                                                  ' Days Left',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: progress[index % 6]),
                                            )
                                          : myProfile.projectsJoined[index]
                                                      .projStatus ==
                                                  "COMPLETED"
                                              ? Text(
                                                  'Completed',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color:
                                                          progress[index % 6]),
                                                )
                                              : Text(
                                                  'Terminated',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color:
                                                          progress[index % 6]),
                                                )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )
                          ],
                        )),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(ProjectManagementOverview.routeName,
                          arguments: myProfile.projectsJoined[index]);
                    },
                  );
                }));
  }

  buildProjectMembers(BuildContext context, Project project) {
    // Provider.of<ManageProject>(context, listen: false).getProject(
    //     project.projectId,
    //     Provider.of<Auth>(context, listen: false).accessToken);
    // project = Provider.of<ManageProject>(context).managedProject;
    print(project.teamMembers);
    List<Widget> members = [];
    members.add(Container(
        height: 60,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                ...project.teamMembers
                    .asMap()
                    .map(
                      (i, e) => MapEntry(
                        i,
                        Transform.translate(
                          offset: Offset(i * 30.0, 0),
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
          ],
        )));

    return members;
  }

  _buildAvatar(TruncatedProfile e, {double radius = 40}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: ClipOval(
        child: AttachmentImage(e.profilePhoto),
      ),
    );
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
