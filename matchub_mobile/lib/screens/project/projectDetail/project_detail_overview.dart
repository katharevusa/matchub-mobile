import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/profile_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/project/projectCreation/project_creation_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pActions.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pAnnouncement.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pCarousel.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pDescription.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pFounderTeamAttachBadgeSDG.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pProgressBar.dart';
import 'package:matchub_mobile/screens/project/projectDetail/resourceDonate.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pSDGs.dart';

class ProjectDetailScreen extends StatefulWidget {
  static const routeName = "/project-details";
  Project project;

  ProjectDetailScreen({this.project});

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  bool _isLoading;
  Future loadProject;
  Future loadCreator;
  Project project;
  List<String> documentKeys;
  Profile myProfile;
  Profile creator;
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  GlobalKey<ScaffoldState> _projectDetailScaffoldKey = GlobalKey();
  @override
  void initState() {
    _isLoading = false;
    project = widget.project;
    print(project.teamMembers);
    loadProject = getProjects();
    loadCreator = getCreator();
    super.initState();
  }

  getProjects() async {
    await Provider.of<ManageProject>(this.context, listen: false).getProject(
      widget.project.projectId,
    );
  }

  getCreator() async {
    final url = 'authenticated/getAccount/${project.projCreatorId}';
    final responseData = await _helper.getProtected(url);
    creator = Profile.fromJson(responseData);
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;
    // project = Provider.of<ManageProject>(context).managedProject;
    return FutureBuilder(
      future: loadCreator,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Consumer<ManageProject>(
              builder: (context, project, child) => Scaffold(
                backgroundColor: Colors.white,
                key: _projectDetailScaffoldKey,
                body: _isLoading
                    ? Container()
                    : SingleChildScrollView(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      minHeight:
                                          20 * SizeConfig.heightMultiplier),
                                  child: PDetailHeader(),
                                ),
                                Container(
                                  width: 100 * SizeConfig.widthMultiplier,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 30),
                                          leading:
                                              buildAvatar(creator, radius: 50),
                                          title: Text(
                                            creator.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text("Project creator"),
                                        ),
                                        PDetailTitle(project.managedProject),
                                        PProgressBar(project.managedProject),
                                        PDescription(project.managedProject),
                                        PAnnouncement(project.managedProject),
                                        PFounderTeamAttachBadgeSDG(
                                            project.managedProject),
                                        SizedBox(height: 100),
                                        project.managedProject.projCreatorId ==
                                                Provider.of<Auth>(context,
                                                        listen: false)
                                                    .myProfile
                                                    .accountId
                                            ? Container()
                                            : PActions(project.managedProject)
                                      ]),
                                ),
                              ],
                            ),
                            // Positioned(
                            //     top: 28.2 * SizeConfig.heightMultiplier,
                            //     right: 40,
                            //     child: FloatingActionButton(
                            //       elevation: 5,
                            //       backgroundColor: Colors.white,
                            //       splashColor: kKanbanColor, // inkwell color
                            //       child: SizedBox(
                            //           width: 48,
                            //           height: 48,
                            //           child: Icon(Icons.bookmark,
                            //               size: 30,
                            //               color: Colors.blueGrey[100])),
                            //       onPressed: () {},
                            //     )),
                          ],
                        ),
                      ),
              ),
            )
          : Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class PDetailTitle extends StatelessWidget {
  PDetailTitle(@required this.project);

  Project project;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: Text(
              project.projectTitle,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 2.6 * SizeConfig.textMultiplier),
            ),
          ),
          Flexible(
            flex: 1,
            child: FittedBox(
              child: CircularPercentIndicator(
                center: project.startDate.isAfter(DateTime.now())
                    ? Text("0 %",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.project6,
                        ))
                    : DateTime.now().isAfter(project.endDate)
                        ? Text("100 %",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.project6,
                            ))
                        : Text(
                            ((DateTime.now()
                                            .difference(project.startDate)
                                            .inDays /
                                        (project.endDate
                                            .difference(project.startDate)
                                            .inDays
                                            .toDouble()) *
                                        100)
                                    .toStringAsFixed(1) +
                                " %"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.project6,
                            )),
                radius: 100.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent: project.startDate.isAfter(DateTime.now())
                    ? 0.0
                    : DateTime.now().isAfter(project.endDate)
                        ? 1.0
                        : (DateTime.now().difference(project.startDate).inDays /
                                (project.endDate
                                    .difference(project.startDate)
                                    .inDays
                                    .toDouble()) *
                                100) /
                            100,
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.blueGrey[200].withOpacity(0.5),
                progressColor: AppTheme.project6,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PDetailHeader extends StatelessWidget {
  const PDetailHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Project project = Provider.of<ManageProject>(context).managedProject;
    return Stack(overflow: Overflow.visible, children: <Widget>[
      PCarousel(project),
      AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10)),
                height: 84,
                width: 84,
                child:
                    Center(child: Icon(Icons.close, color: Colors.grey[200]))),
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      Positioned(bottom: 0, child: PSdgTags())
    ]);
  }
}

final List<String> iconList = [
  "assets/icons/word.png",
  "assets/icons/ppt.png",
  "assets/icons/excel.png",
  "assets/icons/pdf.png",
];

/*  actions: [
                    IconButton(
                      alignment: Alignment.bottomCenter,
                      visualDensity: VisualDensity.comfortable,
                      icon: Icon(
                        FlutterIcons.ellipsis_v_faw5s,
                        size: 20,
                        color: Colors.grey[800],
                      ),
                      onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => buildMorePopUp(context))
                          .then((value) {
                        setState(() {
                          _isLoading = true;
                        });
                        getProjects();
                        switch (value) {
                          case "Joined-Project":
                            _projectDetailScaffoldKey.currentState
                                .showSnackBar(new SnackBar(
                              content: Text(
                                "You've applied to join: ${project.managedProject.projectTitle}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              duration: Duration(seconds: 2),
                            ));
                            break;
                          case "Delete-Project":
                            _projectDetailScaffoldKey.currentState
                                .showSnackBar(new SnackBar(
                              content: Text(
                                "You've have left the project: ${project.managedProject.projectTitle}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              duration: Duration(seconds: 2),
                            ));
                            break;
                          default:
                            break;
                        }
                      }),
                    ),
                  ],*/

// trailing: IconButton(
//   icon: Icon(
//       FlutterIcons.share_google_evi),
//   onPressed: () {
//     Share.share(
//         'Hey there! Ever heard of the United Nation\'s Sustainable Development Goals?\nCheck out this project on: ${project.managedProject.projectTitle}\nhttp://localhost:3000/project/${project.managedProject.projectId}');
//   },
// ),
