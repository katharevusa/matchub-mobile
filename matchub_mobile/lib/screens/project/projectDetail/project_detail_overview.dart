import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectCreation/project_creation_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/resourceDonate.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
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
  Project project;
  List<String> documentKeys;
  Profile myProfile;

  GlobalKey<ScaffoldState> _projectDetailScaffoldKey = GlobalKey();
  @override
  void initState() {
    _isLoading = false;
    project = widget.project;
    loadProject = getProjects();
    super.initState();
  }

  getProjects() async {
    final responseData = await ApiBaseHelper().getProtected(
        "authenticated/getProject?projectId=${widget.project.projectId}",
        Provider.of<Auth>(this.context, listen: false).accessToken);

    project = Project.fromJson(responseData);
    documentKeys = project.documents.keys.toList();

    setState(() => _isLoading = false);
  }

  List<Widget> getPhotoList(photos) {
    List<Widget> finalList = [];
    photos.forEach((item) {
      finalList.add(Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            offset: Offset(4, 10),
            blurRadius: 10,
            color: Colors.grey[300].withOpacity(0.2),
          ),
          BoxShadow(
            offset: Offset(-4, 10),
            blurRadius: 30,
            color: Colors.grey[300].withOpacity(0.2),
          ),
        ]),
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 6,
            vertical: SizeConfig.heightMultiplier * 2),
        child: Material(
          elevation: 1 * SizeConfig.heightMultiplier,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Stack(
                children: <Widget>[
                  Container(
                      width: 100 * SizeConfig.widthMultiplier,
                      child: AttachmentImage(item)),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Text(
                        // 'No. ${imgList.indexOf(item)} image',
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ));
    });
    return finalList;
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;

    return Scaffold(
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
          actions: [
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
                  builder: (context) => buildMorePopUp(context)).then((value) {
                setState(() {
                  _isLoading = true;
                });
                getProjects();
                switch (value) {
                  case "Joined-Project":
                    _projectDetailScaffoldKey.currentState
                        .showSnackBar(new SnackBar(
                      content: Text(
                        "You've applied to join: ${project.projectTitle}",
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
                        "You've have left the project: ${project.projectTitle}",
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
          ],
          backgroundColor: AppTheme.appBackgroundColor,
          elevation: 0,
        ),
        body: _isLoading
            ? Container()
            : SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0 * SizeConfig.widthMultiplier),
                        child: Text(
                          project.projectTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 3.2 * SizeConfig.textMultiplier),
                        ),
                      ),
                      UpvoteRow(
                          project: project,
                          myProfile: myProfile,
                          getProjects: getProjects),
                      Hero(
                        tag: project.projectProfilePic,
                        child: CarouselSlider(
                          options: CarouselOptions(
                              autoPlay: false,
                              aspectRatio: 1.8,
                              viewportFraction: 1.0,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false),
                          items: (project.photos.isNotEmpty)
                              ? getPhotoList(project.photos)
                              : getPhotoList(imgList),
                        ),
                      ),
                      ...buildDescription(),
                      ...buildFoundersRow(),
                      ...buildTeamMemberRow(project.teamMembers),
                      ...buildAttachments(),
                      ...buildBadgeRow(),
                      ...buildSDGRow()
                    ]),
              ));
  }

  List<Widget> buildDescription() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: 0.5 * SizeConfig.heightMultiplier,
            horizontal: 8.0 * SizeConfig.widthMultiplier),
        child: Text(
          "PROJECT DESCRIPTION",
          style: TextStyle(
              color: Colors.grey[600], fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: 0.5 * SizeConfig.heightMultiplier,
            horizontal: 8.0 * SizeConfig.widthMultiplier),
        child: ReadMoreText(
          project.projectDescription +
              project.projectDescription +
              "\n\nStatus: ${project.projStatus}"
                  "\nStart Date: ${DateFormat('dd-MMM-yyyy ').format(project.startDate)}" +
              "\nEnd Date: ${DateFormat('dd-MMM-yyyy ').format(project.endDate)}\n",
          trimLines: 3,
          style: TextStyle(
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.justify,
          colorClickableText: kSecondaryColor,
          trimMode: TrimMode.Line,
          trimCollapsedText: '...Show more',
          trimExpandedText: 'show less',
        ),
      )
    ];
  }

  List<Widget> buildAttachments() {
    return (project.documents.isNotEmpty)
        ? [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 1 * SizeConfig.heightMultiplier,
                  horizontal: 8.0 * SizeConfig.widthMultiplier),
              child: Text(
                "ATTACHMENTS",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: SizeConfig.textMultiplier * 2),
              ),
            ),
            Container(
              color: AppTheme.appBackgroundColor,
              height: 28 * SizeConfig.widthMultiplier,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      horizontal: 4.0 * SizeConfig.widthMultiplier),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () async {
                          String fileName =
                              (project.documents[documentKeys[index]]);
                          String url =
                              ApiBaseHelper().baseUrl + fileName.substring(30);
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                          // OpenFile.open(
                          //     "https://192.168.1.55:8443/api/v1/files/att-7062382057131087005.pdf");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 2 * SizeConfig.widthMultiplier,
                              vertical: 2 * SizeConfig.heightMultiplier),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              offset: Offset(4, 10),
                              blurRadius: 6,
                              color: Colors.grey[400].withOpacity(0.15),
                            ),
                            BoxShadow(
                              offset: Offset(-4, 10),
                              blurRadius: 6,
                              color: Colors.grey[400].withOpacity(0.15),
                            ),
                          ]),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                padding: EdgeInsets.all(
                                    1 * SizeConfig.heightMultiplier),
                                color: Colors.white,
                                width: 20 * SizeConfig.widthMultiplier,
                                // height:
                                //     20 * SizeConfig.widthMultiplier,
                                child: getDocumentImage(documentKeys[index]),
                              )),
                        ),
                      ),
                  itemCount: project.documents.keys.toList().length),
            )
          ]
        : [SizedBox.shrink()];
  }

  List<Widget> buildFoundersRow() {
    return [
      Padding(
        padding: EdgeInsets.only(
            top: 1.5 * SizeConfig.heightMultiplier,
            right: 8.0 * SizeConfig.widthMultiplier,
            left: 8.0 * SizeConfig.widthMultiplier),
        child: Text(
          "MEET THE FOUNDERS",
          style: TextStyle(
              color: Colors.grey[600], fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      Container(
        // padding: EdgeInsets.all(0),
        // margin: EdgeInsets.all(0),
        // color: AppTheme.appBackgroundColor,
        height: 16 * SizeConfig.heightMultiplier,
        child: ListView.builder(
            cacheExtent: 20,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
                horizontal: 6.0 * SizeConfig.widthMultiplier),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(0),
                // padding: EdgeInsets.symmetric(
                // horizontal:
                //     2 * SizeConfig.widthMultiplier,
                // vertical:
                //     1 * SizeConfig.heightMultiplier),
                // constraints:
                //     BoxConstraints(minHeight: 18 * SizeConfig.heightMultiplier),
                margin: EdgeInsets.symmetric(
                    horizontal: 2 * SizeConfig.widthMultiplier,
                    vertical: 2 * SizeConfig.heightMultiplier),
                child: Column(children: [
                  ClipOval(
                      // borderRadius: BorderRadius.circular(50),
                      child: Container(
                          color: Colors.white,
                          height: 16 * SizeConfig.widthMultiplier,
                          width: 16 * SizeConfig.widthMultiplier,
                          child: AttachmentImage(
                              project.projectOwners[index].profilePhoto))),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 20 * SizeConfig.widthMultiplier,
                          minWidth: 15 * SizeConfig.widthMultiplier),
                      child: Text(
                        project.projectOwners[index].name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  )
                ]),
              );
            },
            itemCount: project.projectOwners.length),
      )
    ];
  }

  List<Widget> buildBadgeRow() {
    print(project.projectBadge);
    if (project.projectBadge != null) {
      return [
        Padding(
          padding: EdgeInsets.only(
              top: 1.5 * SizeConfig.heightMultiplier,
              right: 8.0 * SizeConfig.widthMultiplier,
              left: 8.0 * SizeConfig.widthMultiplier),
          child: Text(
            "PROJECT BADGE",
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: SizeConfig.textMultiplier * 2),
          ),
        ),
        Container(
            padding: EdgeInsets.only(left: 8.0 * SizeConfig.widthMultiplier),
            height: 12 * SizeConfig.heightMultiplier,
            width: 12 * SizeConfig.heightMultiplier,
            child: Center(
                child: Tooltip(
                    message: project.projectBadge.badgeTitle,
                    child: AttachmentImage(project.projectBadge.icon))))
      ];
    } else {
      return [SizedBox.shrink()];
    }
    ;
  }

  Widget _buildAvatar(profile, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: ClipOval(
        child: AttachmentImage(profile.profilePhoto),
      ),
    );
  }

  List<Widget> buildTeamMemberRow(List<TruncatedProfile> members) {
    return (members.isNotEmpty)
        ? [
            Padding(
              padding: EdgeInsets.only(
                  top: 1.5 * SizeConfig.heightMultiplier,
                  right: 8.0 * SizeConfig.widthMultiplier,
                  left: 8.0 * SizeConfig.widthMultiplier),
              child: Text(
                "MEET THE TEAM MEMBERS",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: SizeConfig.textMultiplier * 2),
              ),
            ),
            Container(
                // height: 60,
                width: SizeConfig.widthMultiplier * 100,
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
                margin: EdgeInsets.symmetric(
                    vertical: 5 * SizeConfig.widthMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        ...members
                            .asMap()
                            .map(
                              (i, e) => MapEntry(
                                i,
                                Transform.translate(
                                  offset: Offset(i * 40.0, 0),
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
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => ViewOrganisationMembersScreen(
                        //             user: widget.profile)));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(width: 1, color: Colors.black),
                          image: DecorationImage(
                              image: AssetImage(
                                  './././assets/images/view-more-icon.jpg'),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ],
                ))
          ]
        : [];
  }

  List<Widget> buildSDGRow() {
    return [
      Padding(
        padding: EdgeInsets.only(
            top: 1.5 * SizeConfig.heightMultiplier,
            right: 8.0 * SizeConfig.widthMultiplier,
            left: 8.0 * SizeConfig.widthMultiplier),
        child: Text(
          "RELATED SDGS",
          style: TextStyle(
              color: Colors.grey[600], fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      Container(
        padding: EdgeInsets.all(20),
        width: 100 * SizeConfig.widthMultiplier,
        // constraints: BoxConstraints(
        //     minHeight: SizeConfig.heightMultiplier * 10,
        //     maxHeight: SizeConfig.heightMultiplier * 30),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Tags(
              itemCount: project.sdgs.length, // required
              itemBuilder: (int index) {
                return ItemTags(
                  key: Key(index.toString()),
                  index: index, // required
                  title: project.sdgs[index].sdgName,
                  color: kScaffoldColor,
                  border: Border.all(color: Colors.grey[400]),
                  textColor: Colors.grey[600],
                  elevation: 0,
                  active: false,
                  pressEnabled: false,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
                );
              },
              alignment: WrapAlignment.end,
              runAlignment: WrapAlignment.start,
              spacing: 6,
              runSpacing: 6,
            ),
          ),
        ]),
      )
    ];
  }

  Container buildMorePopUp(BuildContext context) {
    return Container(
        height: 300,
        child: Column(
          children: [
            FlatButton(
                onPressed: () {
                  Share.share(
                      'Hey there! Ever heard of the United Nation\'s Sustainable Development Goals?\nCheck out this project on: ${project.projectTitle}\nhttp://localhost:3000/project/${project.projectId}');
                },
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.share_square_faw5s,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Share", style: AppTheme.titleLight),
                  ],
                )),
            FlatButton(
                onPressed: () {},
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.user_plus_faw5s,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Follow", style: AppTheme.titleLight),
                  ],
                )),
            if (project.teamMembers.indexWhere((element) =>
                        element.accountId == myProfile.accountId) ==
                    -1
                // && project.joinRequests.indexWhere((element) => element.requestor.accountId==myProfile.accountId) == -1
                &&
                project.projectOwners.indexWhere((element) =>
                        element.accountId == myProfile.accountId) ==
                    -1) //Only able to join a project that Not currently part of,jave not applied to, not the owenr for
              FlatButton(
                  onPressed: () async {
                    await joinProject();
                    Provider.of<Auth>(context).retrieveUser();
                  },
                  visualDensity: VisualDensity.comfortable,
                  highlightColor: Colors.transparent,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          FlutterIcons.user_friends_faw5s,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Join Team", style: AppTheme.titleLight),
                    ],
                  )),
            if (project.teamMembers.indexWhere(
                    (element) => element.accountId == myProfile.accountId) >
                -1)
              //only able to leave a projct that youre a team member of
              FlatButton(
                  onPressed: () async {
                    await leaveProject();
                    Provider.of<Auth>(context).retrieveUser();
                  },
                  visualDensity: VisualDensity.comfortable,
                  highlightColor: Colors.transparent,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          FlutterIcons.user_friends_faw5s,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Leave Project", style: AppTheme.titleLight),
                    ],
                  )),
            if (project.projCreatorId !=
                Provider.of<Auth>(context).myProfile.accountId) ...[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => DonateFormScreen(project)));
                  },
                  visualDensity: VisualDensity.comfortable,
                  highlightColor: Colors.transparent,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          FlutterIcons.donate_faw5s,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Contribute Resource", style: AppTheme.titleLight),
                    ],
                  )),
            ],
            if (project.projCreatorId ==
                Provider.of<Auth>(context).myProfile.accountId) ...[
              FlatButton(
                  onPressed: () => Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                              ProjectCreationScreen(newProject: project))),
                  visualDensity: VisualDensity.comfortable,
                  highlightColor: Colors.transparent,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          FlutterIcons.edit_2_fea,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Edit Project", style: AppTheme.titleLight),
                    ],
                  )),
              if (project.projStatus == "ACTIVE")
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _completeDialog(context);
                    },
                    visualDensity: VisualDensity.comfortable,
                    highlightColor: Colors.transparent,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.check_box_outlined,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Mark as Complete", style: AppTheme.titleLight),
                      ],
                    )),
              if (project.projStatus == "ACTIVE" || project.projStatus == "ON_HOLD")
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _terminateDialog(context);
                    },
                    visualDensity: VisualDensity.comfortable,
                    highlightColor: Colors.transparent,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            FlutterIcons.stop_circle_faw,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Terminate", style: AppTheme.titleLight),
                      ],
                    ))
            ],
          ],
        ));
  }

  markProjectAsComplete() async {
    final url =
        "authenticated/completeProject?projectId=${widget.project.projectId}&profileId=${myProfile.accountId}";
    try {
      var accessToken = Provider.of<Auth>(this.context).accessToken;
      final response =
          await ApiBaseHelper().putProtected(url, accessToken: accessToken);
      print("Success");
      Navigator.of(this.context).pop("Completed-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }

  joinProject() async {
    final url =
        "authenticated/createJoinRequest?projectId=${widget.project.projectId}&profileId=${myProfile.accountId}";
    try {
      var accessToken = Provider.of<Auth>(this.context).accessToken;
      final response =
          await ApiBaseHelper().postProtected(url, accessToken: accessToken);
      print("Success");
      Navigator.of(this.context).pop("Joined-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }

  leaveProject() async {
    final url =
        "authenticated/leaveProject?projectId=${widget.project.projectId}&memberId=${myProfile.accountId}";
    try {
      var accessToken = Provider.of<Auth>(this.context).accessToken;
      final response =
          await ApiBaseHelper().deleteProtected(url, accessToken: accessToken);

      await DatabaseMethods()
          .removeFromChannels(myProfile.uuid, widget.project.projectId);
      print("Success");
      Navigator.of(this.context).pop("Delete-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }

  void terminateProject() async {
    final url =
        "authenticated/terminateProject?projectId=${widget.project.projectId}&profileId=${myProfile.accountId}";
    try {
      var accessToken = Provider.of<Auth>(this.context).accessToken;
      final response =
          await ApiBaseHelper().putProtected(url, accessToken: accessToken);
      print("Success");
      Navigator.of(this.context).pop(true);
    } catch (error) {
      // final responseData = error.body as Map<String, dynamic>;
      print("Failure");
      showErrorDialog(error.toString(), this.context);
      // showDialog(
      //     context: this.context,
      //     builder: (ctx) => AlertDialog(
      //           title: Text(responseData['error']),
      //           content: Text(responseData['message']),
      //           actions: <Widget>[
      //             FlatButton(
      //               child: Text('Okay'),
      //               onPressed: () {
      //                 Navigator.of(ctx).pop();
      //               },
      //             )
      //           ],
      //         ));
    }
  }

  _completeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(right: 16.0),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75),
                      bottomLeft: Radius.circular(75),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                      image: AssetImage(
                        './././assets/images/info-icon.png',
                      ),
                    ))),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Alert!",
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(height: 10.0),
                        Flexible(
                          child: Text(
                              "Do you want to mark this project as complete?"),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                child: Text("No"),
                                color: Colors.red,
                                colorBrightness: Brightness.dark,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: RaisedButton(
                                child: Text("Yes"),
                                color: Colors.green,
                                colorBrightness: Brightness.dark,
                                onPressed: () async {
                                  await markProjectAsComplete();
                                  Navigator.of(this.context).pop();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _terminateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(right: 16.0),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75),
                      bottomLeft: Radius.circular(75),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                      image: AssetImage(
                        './././assets/images/info-icon.png',
                      ),
                    ))),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Alert!",
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(height: 10.0),
                        Flexible(
                          child: Text("Do you want to terminate the project?"),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                child: Text("No"),
                                color: Colors.red,
                                colorBrightness: Brightness.dark,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: RaisedButton(
                                child: Text("Yes"),
                                color: Colors.green,
                                colorBrightness: Brightness.dark,
                                onPressed: () {
                                  terminateProject();
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getDocumentImage(String fileName) {
    int ext = 0;
    switch (extension(fileName)) {
      case '.docx':
        {
          ext = 0;
        }
        break;
      case '.doc':
        {
          ext = 0;
        }
        break;
      case '.ppt':
        {
          ext = 1;
        }
        break;
      case '.xlsx':
        {
          ext = 2;
        }
        break;
      default:
        ext = 3;
    }
    return Image.asset(
      iconList[ext],
      fit: BoxFit.contain,
    );
  }
}

class UpvoteRow extends StatefulWidget {
  UpvoteRow({
    Key key,
    @required this.project,
    @required this.myProfile,
    @required this.getProjects,
  }) : super(key: key);
  Function getProjects;
  final Project project;
  final Profile myProfile;

  @override
  _UpvoteRowState createState() => _UpvoteRowState();
}

class _UpvoteRowState extends State<UpvoteRow> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(
              top: 1 * SizeConfig.heightMultiplier,
              left: 8.0 * SizeConfig.widthMultiplier),
          child: Text(
              "${widget.project.upvotes} upvotes | ${widget.project.userFollowers.length} following",
              style: AppTheme.unSelectedTabLight),
        ),
      ),
      IconButton(
          icon: Icon(
            Icons.thumb_up,
            color: widget.myProfile.upvotedProjectIds
                    .contains(widget.project.projectId)
                ? kAccentColor
                : Colors.grey[300],
          ),
          onPressed: () async {
            if (!widget.myProfile.upvotedProjectIds
                .contains(widget.project.projectId)) {
              await ApiBaseHelper().postProtected(
                  "authenticated/upvoteProject?projectId=${widget.project.projectId}&userId=${widget.myProfile.accountId}",
                  accessToken: Provider.of<Auth>(context).accessToken);
            } else {
              await ApiBaseHelper().postProtected(
                  "authenticated/revokeUpvote?projectId=${widget.project.projectId}&userId=${widget.myProfile.accountId}",
                  accessToken: Provider.of<Auth>(context).accessToken);
            }

            await Provider.of<Auth>(context).retrieveUser();
            setState(() {
              widget.getProjects();
            });
          })
    ]);
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
