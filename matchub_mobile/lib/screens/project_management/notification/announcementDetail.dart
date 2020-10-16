import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/resource_incoming_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_outgoing/resource_outgoing_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_notification.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

import '../../../style.dart';

class AnnouncementDetail extends StatefulWidget {
  static const routeName = "/announcement-detail";
  Announcement announcement;
  bool isProjectOnwer;

  AnnouncementDetail({
    this.announcement,
    this.isProjectOnwer,
  });
  @override
  _AnnouncementDetailState createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  ApiBaseHelper _helper = ApiBaseHelper();
  Profile creator;
  Future loadFuture;
  Project project;

  @override
  void initState() {
    loadFuture = loading();
    print("============="+widget.isProjectOnwer.toString());
    super.initState();
  }

  getCreator() async {
    final url = 'authenticated/getAccount/${widget.announcement.creatorId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    creator = Profile.fromJson(responseData);
    // await retrieveProject();
  }

  retrieveProject() async {
    final responseData = await ApiBaseHelper().getProtected(
        "authenticated/getProject?projectId=${widget.announcement.projectId}",
        Provider.of<Auth>(this.context, listen: false).accessToken);
    project = Project.fromJson(responseData);
  }

  loading() async {
    if (widget.announcement.creatorId != null) {
      await getCreator();
      await retrieveProject();
    }
  }

  loadAnnouncements() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectInternal(project, profile, accessToken);
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectPublic(project, profile, accessToken);
  }

  deleteAnnouncement() async {
    var profileId = Provider.of<Auth>(context).myProfile.accountId;
    if (widget.announcement.type == "PROJECT_INTERNAL_ANNOUNCEMENT" &&
        widget.announcement.creatorId == profileId) {
      final url =
          "authenticated/deleteProjectInternalAnnouncement?announcementId=${widget.announcement.announcementId}&userId=${profileId}";
      try {
        var accessToken = Provider.of<Auth>(context).accessToken;
        final responseData = await ApiBaseHelper().deleteProtected(url,
            accessToken: Provider.of<Auth>(context).accessToken);
        print("Success");
        await loadAnnouncements();
        // Provider.of<Auth>(context).retrieveUser();
        Navigator.of(context).pop(true);
      } catch (error) {
        final responseData = error.body as Map<String, dynamic>;
        print("Failure");
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(responseData['error']),
                  content: Text(responseData['message']),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    } else if (widget.announcement.type == "PROJECT_PUBLIC_ANNOUNCEMENT" &&
        widget.announcement.creatorId == profileId) {
      final url =
          "authenticated/deleteProjectPublicAnnouncement?announcementId=${widget.announcement.announcementId}&userId=${profileId}";
      try {
        var accessToken = Provider.of<Auth>(context).accessToken;
        final responseData = await ApiBaseHelper().deleteProtected(url,
            accessToken: Provider.of<Auth>(context).accessToken);
        print("Success");
        await loadAnnouncements();
        Navigator.of(context).pop(true);
      } catch (error) {
        final responseData = error.body as Map<String, dynamic>;
        print("Failure");
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(responseData['error']),
                  content: Text(responseData['message']),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    } else if (widget.announcement.creatorId == null) {
      final url =
          "authenticated/deleteAnAnnouncementForUser?announcementId=${widget.announcement.announcementId}&userId=${profileId}";
      try {
        var accessToken = Provider.of<Auth>(context).accessToken;
        final responseData = await ApiBaseHelper().deleteProtected(url,
            accessToken: Provider.of<Auth>(context).accessToken);
        print("Success");
        // Provider.of<Auth>(context).retrieveUser();
        Navigator.of(context).pop(true);
      } catch (error) {
        final responseData = error.body as Map<String, dynamic>;
        print("Failure");
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(responseData['error']),
                  content: Text(responseData['message']),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: kScaffoldColor,
                elevation: 0,
                title: Text("Announcement Details",
                    style: TextStyle(color: Colors.black)),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _terminateDialog(context);
                    },
                  )
                ],
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: 300,
                          width: double.infinity,
                          child: Image.asset("assets/images/announcement.gif")),
                      Container(
                        margin: EdgeInsets.fromLTRB(16.0, 250.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.announcement.title,
                              style: Theme.of(context).textTheme.title,
                            ),
                            SizedBox(height: 10.0),
                            widget.announcement.type ==
                                        "PROJECT_INTERNAL_ANNOUNCEMENT" ||
                                    widget.announcement.type ==
                                        "PROJECT_PUBLIC_ANNOUNCEMENT"
                                ? Text(
                                    "${widget.announcement.timestamp.year}-${widget.announcement.timestamp.month}-${widget.announcement.timestamp.day} ${widget.announcement.timestamp.hour}:${widget.announcement.timestamp.minute}:${widget.announcement.timestamp.second} " +
                                        " by " +
                                        creator.name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 10.0),
                            widget.announcement.type ==
                                        "PROJECT_INTERNAL_ANNOUNCEMENT" ||
                                    widget.announcement.type ==
                                        "PROJECT_PUBLIC_ANNOUNCEMENT"
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pushNamed(ProjectDetailScreen.routeName,
                                          arguments: project);
                                    },
                                    child: Text(
                                      project.projectTitle,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ))
                                : widget.announcement.type ==
                                        "NEW_PROFILE_FOLLOWER"
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pushNamed(
                                              ProjectDetailScreen.routeName,
                                              arguments: project);
                                        },
                                        child: Text(
                                          project.projectTitle,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ))
                                    : Container(),
                            widget.announcement.type ==
                                        "RESOURCE_REQUEST_ACCEPTED" ||
                                    widget.announcement.type ==
                                        "RESOURCE_REQUEST_REJECTED"
                                // widget.announcement.type ==
                                //     "DONATE_TO_PROJECT"
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  IncomingRequestScreen()));
                                    },
                                    child: Text(
                                      "Check out the request",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ))
                                : Container(),
                            widget.announcement.type == "DONATE_TO_PROJECT" ||
                                    widget.announcement.type == ""
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  OutgoingRequestScreen()));
                                    },
                                    child: Text(
                                      "Check out the request",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ))
                                : Container(),
                            Divider(),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.announcement.content,
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
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
                          child: Text("Do you want delete this announcement?"),
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
                                  deleteAnnouncement();
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
}