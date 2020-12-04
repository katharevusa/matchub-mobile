import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/about/projectAnnouncement.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/projectAbout.dart';
import 'package:matchub_mobile/services/manageNotification.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

import 'channels/channelScreen.dart';
import 'pManagementComponent/pFundCampaign.dart';
import 'pManagementComponent/projectMatchedResources.dart';
import 'pManagementComponent/teamMemberManagement.dart';

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
  bool isLoaded = false;
  Profile myProfile;
  @override
  void initState() {
    loadProject();
    loadAnnouncements();
  }

  refreshState() {
    setState(() {
      isLoaded = false;
    });
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    // widget.project = Provider.of<ManageProject>(context, listen:false).managedProject;
    publicAnnouncements =
        Provider.of<ManageNotification>(context, listen: false)
            .projectPublicAnnouncement;
    internalAnnouncements =
        Provider.of<ManageNotification>(context, listen: false)
            .projectInternalAnnouncement;
    _children = [
      SingleChildScrollView(
        child: PManagementAbout(
          myProfile: myProfile,
          internalAnnouncements: internalAnnouncements,
          publicAnnouncements: publicAnnouncements,
          project: Provider.of<ManageProject>(context, listen:false).managedProject,
          loadProject: loadProject,
        ),
      ),
      ChannelsScreen(
        project: widget.project,
      ),
      TeamMembersManagement(
        project: widget.project,
      ),
      PFundCampaignList(),
      PManagementMatchedResources(widget.project),
    ];
  }

  loadAnnouncements() async {
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectInternal(widget.project, myProfile, accessToken);
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectPublic(widget.project, myProfile, accessToken);
    await refreshState();
    setState(() {
      isLoaded = true;
    });
  }

  loadProject() async {
    await Provider.of<ManageProject>(context, listen: false).getProject(
      widget.project.projectId,
    );
  }
  int _currentIndex = 0;
  List<Widget> _children = [];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<ManageProject>(context).managedProject.projectTitle);
    return SafeArea(
      child: Scaffold(
        body: isLoaded
            ? _children[_currentIndex]
            : Container(child: Center(child: CircularProgressIndicator())),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          unselectedItemColor: Colors.grey[400],
          selectedItemColor: kSecondaryColor,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.developer_board_rounded),
                title: Text('Channels')),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_rounded), title: Text('People')),
            BottomNavigationBarItem(
              icon: new Icon(Icons.monetization_on_rounded),
              title: new Text('Campaigns'),
            ),
            BottomNavigationBarItem(
                icon: Icon(FlutterIcons.luggage_cart_faw5s),
                title: Text('Resources')),
          ],
        ),
      ),
    );
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
                ),
              ),
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
}
