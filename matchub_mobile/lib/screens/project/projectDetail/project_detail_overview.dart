import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
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
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final responseData = await _helper.getProtected(url,
        accessToken:
            Provider.of<Auth>(this.context, listen: false).accessToken);
    creator = Profile.fromJson(responseData);
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;
    project = Provider.of<ManageProject>(context).managedProject;
    return FutureBuilder(
      future: loadCreator,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Consumer<ManageProject>(
              builder: (context, project, child) => Scaffold(
                backgroundColor: Colors.white,
                key: _projectDetailScaffoldKey,
                appBar: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: IconButton(
                      color: Colors.grey[850],
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
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
                  backgroundColor: AppTheme.appBackgroundColor,
                  elevation: 0,
                ),
                body: _isLoading
                    ? Container()
                    : Container(
                        child: Stack(children: <Widget>[
                          Container(
                            height: double.infinity,
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    PCarousel(project.managedProject),
                                    SizedBox(height: 20),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pushNamed(ProfileScreen.routeName,
                                            arguments: creator.accountId);
                                      },
                                      leading: ClipOval(
                                          child: Container(
                                              color: Colors.white,
                                              height: 16 *
                                                  SizeConfig.widthMultiplier,
                                              width: 16 *
                                                  SizeConfig.widthMultiplier,
                                              child: AttachmentImage(
                                                  creator.profilePhoto))),
                                      title: Text(
                                        creator.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text("Resource creator"),
                                      trailing: IconButton(
                                        icon:
                                            Icon(FlutterIcons.share_google_evi),
                                        onPressed: () {
                                          Share.share(
                                              'Hey there! Ever heard of the United Nation\'s Sustainable Development Goals?\nCheck out this project on: ${project.managedProject.projectTitle}\nhttp://localhost:3000/project/${project.managedProject.projectId}');
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              8.0 * SizeConfig.widthMultiplier),
                                      child: Text(
                                        project.managedProject.projectTitle,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 3.2 *
                                                SizeConfig.textMultiplier),
                                      ),
                                    ),
                                    PProgressBar(project.managedProject),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    PDescription(project.managedProject),
                                    PAnnouncement(project.managedProject),
                                    PFounderTeamAttachBadgeSDG(
                                        project.managedProject),
                                    SizedBox(height: 100),
                                  ]),
                            ),
                          ),
                          project.managedProject.projCreatorId ==
                                  Provider.of<Auth>(context, listen: false)
                                      .myProfile
                                      .accountId
                              ? Container()
                              : PActions(project.managedProject)
                        ]),
                      ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

final List<String> imgList = [
  "https://localhost:8443/api/v1/files/init/project-default.jpg",
  // "https://localhost:8443/api/v1/files/init/project3.jpg",
  // "https://localhost:8443/api/v1/files/init/project6.jpg",
];
final List<String> iconList = [
  "assets/icons/word.png",
  "assets/icons/ppt.png",
  "assets/icons/excel.png",
  "assets/icons/pdf.png",
];
