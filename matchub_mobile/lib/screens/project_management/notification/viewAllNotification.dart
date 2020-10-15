import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/notification/announcementDetail.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_notification.dart';
import 'package:matchub_mobile/widgets/WaveClipper.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import '../../../style.dart';

class AllNotifications extends StatefulWidget {
  Project project;
  AllNotifications({this.project});

  @override
  _AllNotificationsState createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  List<Announcement> internalAnnouncements = [];
  List<Announcement> publicAnnouncements = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  Announcement newAnnouncement = new Announcement();
  Map<String, dynamic> announcement;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  bool _isLoading;

  @override
  void initState() {
    announcement = {
      'announcementId': newAnnouncement.announcementId,
      'title': newAnnouncement.title ?? "",
      'content': newAnnouncement.content ?? "",
      'timestamp':
          newAnnouncement.timestamp ?? DateTime.now().toIso8601String(),
      'notifiedUsers': newAnnouncement.notifiedUsers,
      'projectId': newAnnouncement.projectId,
      'taskId': newAnnouncement.taskId ?? null,
      'postId': newAnnouncement.postId ?? null,
      'type': newAnnouncement.type ?? null,
      'viewedUserIds': newAnnouncement.viewedUserIds,
      'creatorId': newAnnouncement.creatorId
    };
    _isLoading = true;
    loadAnnouncements();
    super.initState();
    // publicFuture = getPublicAnnouncements();
  }

  loadAnnouncements() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectInternal(widget.project, profile, accessToken);
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllProjectPublic(widget.project, profile, accessToken);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(child: Center(child: Text("I am loading")))
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: kScaffoldColor,
                elevation: 0,
                title: Text("Project Announcements",
                    style: TextStyle(color: Colors.black)),
                // automaticallyImplyLeading: true,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        labelColor: Colors.white,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BubbleTabIndicator(
                            indicatorRadius: (40),
                            indicatorHeight: 25.0,
                            indicatorColor: kSecondaryColor,
                            tabBarIndicatorSize: TabBarIndicatorSize.tab,
                            padding: EdgeInsets.all(10)),
                        unselectedLabelColor: Colors.grey[600],
                        tabs: [
                          Tab(
                            text: ("Public Announcements"),
                          ),
                          Tab(
                            text: ("Internal Announcements"),
                          ),
                        ]),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  buildPublicAnnouncements(),
                  buildInternalAnnouncements(),
                ],
              ),
            ));
  }

  Widget buildPublicAnnouncements() {
    publicAnnouncements =
        Provider.of<ManageNotification>(context).projectPublicAnnouncement;
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: RaisedButton(
            highlightElevation: 0,
            elevation: 0,
            child: Text(
              "Create Public Announcement",
              style: TextStyle(fontSize: 15),
            ),
            textColor: kSecondaryColor,
            color: Colors.white,
            onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => buildMorePopUp(
                      context,
                      0,
                    )).then((value) => setState(() {})),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  key: _listKey,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: publicAnnouncements.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(
                          AnnouncementDetail.routeName,
                          arguments: {
                            "announcement": publicAnnouncements[index],
                            "isProjectOwner": true
                          },
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Text(
                                  DateFormat('E').format(
                                      publicAnnouncements[index].timestamp),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                ),
                                Text(
                                  publicAnnouncements[index]
                                      .timestamp
                                      .day
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  DateFormat('MMM').format(
                                      publicAnnouncements[index].timestamp),
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 10),
                                )
                              ]),
                              Text(
                                publicAnnouncements[index].title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              /*          child: AnimatedList(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                key: _listKey,
                padding: const EdgeInsets.all(16.0),
                initialItemCount: publicAnnouncements.length,
                itemBuilder: (context, index, animation) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(
                        AnnouncementDetail.routeName,
                        arguments: internalAnnouncements[index],
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Text(
                                DateFormat('E').format(
                                    publicAnnouncements[index].timestamp),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                              Text(
                                publicAnnouncements[index]
                                    .timestamp
                                    .day
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                DateFormat('MMM').format(
                                    publicAnnouncements[index].timestamp),
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 10),
                              )
                            ]),
                            Text(
                              publicAnnouncements[index].title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),*/
              ),
        )
      ],
    );
  }

  Widget buildInternalAnnouncements() {
    internalAnnouncements =
        Provider.of<ManageNotification>(context).projectInternalAnnouncement;
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: RaisedButton(
            highlightElevation: 0,
            elevation: 0,
            child: Text(
              "Create Internal Announcement",
              style: TextStyle(fontSize: 15),
            ),
            textColor: kSecondaryColor,
            color: Colors.white,
            onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => buildMorePopUp(context, 1)),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  key: _listKey,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: internalAnnouncements.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(
                          AnnouncementDetail.routeName,
                          arguments: {
                            "announcement": publicAnnouncements[index],
                            "isProjectOwner": true
                          },
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Text(
                                  DateFormat('E').format(
                                      internalAnnouncements[index].timestamp),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                ),
                                Text(
                                  internalAnnouncements[index]
                                      .timestamp
                                      .day
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  DateFormat('MMM').format(
                                      internalAnnouncements[index].timestamp),
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 10),
                                )
                              ]),
                              Text(
                                internalAnnouncements[index].title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              /*   child: AnimatedList(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                key: _listKey,
                initialItemCount: internalAnnouncements.length,
                itemBuilder: (context, index, animation) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(
                        AnnouncementDetail.routeName,
                        arguments: internalAnnouncements[index],
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Text(
                                DateFormat('E').format(
                                    internalAnnouncements[index].timestamp),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                              Text(
                                internalAnnouncements[index]
                                    .timestamp
                                    .day
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                DateFormat('MMM').format(
                                    internalAnnouncements[index].timestamp),
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 10),
                              )
                            ]),
                            Text(
                              internalAnnouncements[index].title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),*/
              ),
        )
      ],
    );
  }

  Widget buildMorePopUp(BuildContext context, num flag) {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Announcement Title',
                  hintText: 'Type your title here...',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 14),
                  fillColor: Colors.grey[100],
                  hoverColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[850],
                    ),
                  ),
                ),
                // controller: _titleController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                maxLength: 50,
                maxLengthEnforced: true,
                onChanged: (text) {
                  announcement['title'] = text;
                  print(text);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Announcement Message',
                  hintText: 'Type you announcement message here...',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 14),
                  fillColor: Colors.grey[100],
                  hoverColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[850],
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 3,
                maxLength: 500,
                maxLengthEnforced: true,
                onChanged: (text) {
                  announcement['content'] = text;
                  print(announcement['content']);
                },
              ),
            ),
            RaisedButton(
              child: flag == 0
                  ? Text("Create Public Announcement")
                  : Text("Create Internal Announcement"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                createAnnouncement(flag);
              },
            ),
          ],
        ),
      ),
    );
  }

  createAnnouncement(num flag) async {
    announcement['projectId'] = widget.project.projectId;
    announcement['creatorId'] = Provider.of<Auth>(context).myProfile.accountId;

    var url;
    if (flag == 0) {
      url = "authenticated/createProjectPublicAnnouncement";
    } else {
      url = "authenticated/createProjectInternalAnnouncement";
    }
    var accessToken = Provider.of<Auth>(context).accessToken;
    try {
      final response = await ApiBaseHelper().postProtected(url,
          accessToken: accessToken, body: json.encode(announcement));

      newAnnouncement = new Announcement();
      await loadAnnouncements();
      internalAnnouncements =
          Provider.of<ManageNotification>(context).projectInternalAnnouncement;
      publicAnnouncements =
          Provider.of<ManageNotification>(context).projectPublicAnnouncement;

      // int insertIndex = 0;
      // if (flag == 0) {
      //   publicAnnouncements.insert(
      //       insertIndex, Announcement.fromJson(response));
      //   _listKey.currentState.insertItem(insertIndex);

      // } else {
      //   internalAnnouncements.insert(
      //       insertIndex, Announcement.fromJson(response));
      //   _listKey.currentState.insertItem(insertIndex);

      // }
      print("Success");
      // await loadAnnouncements();
      Navigator.of(context).pop(true);
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }
}
