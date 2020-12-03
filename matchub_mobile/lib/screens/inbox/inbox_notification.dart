import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/notification/announcementDetail.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_notification.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';

class InboxNotification extends StatefulWidget {
  @override
  _InboxNotificationState createState() => _InboxNotificationState();
}

class _InboxNotificationState extends State<InboxNotification> {
  List<Announcement> allAnnouncements = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  Profile user;

  bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    loadNotifications();
    super.initState();
  }

  loadNotifications() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageNotification>(context, listen: false)
        .getAllAnnouncementForUsers(profile, accessToken);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    allAnnouncements =
        Provider.of<ManageNotification>(context).allAnnouncementForUsers;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      FlatButton(
                          onPressed: () async {
                            await readAllAnnouncement();
                          },
                          child: Text(
                            "Read All",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2 * SizeConfig.textMultiplier),
                          )),
                      FlatButton(
                          onPressed: () async {
                            await deleteAllAnnouncement();
                          },
                          child: Text(
                            "Delete All",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2 * SizeConfig.textMultiplier),
                          )),
                    ],
                  ),
                  ListView.separated(
                    reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      padding: const EdgeInsets.all(16.0),
                      shrinkWrap: true,
                      itemCount: allAnnouncements.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(
                              AnnouncementDetail.routeName,
                              arguments: {
                                "announcement": allAnnouncements[index],
                                "isProjectOwner": false
                              },
                            );
                          },
                          child: ListTile(
                            trailing: Column(children: [
                              Text(
                                DateFormat('E')
                                    .format(allAnnouncements[index].timestamp),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                              Text(
                                allAnnouncements[index]
                                    .timestamp
                                    .day
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                DateFormat('MMM')
                                    .format(allAnnouncements[index].timestamp),
                                style:
                                    TextStyle(color: kTertiaryColor, fontSize: 10),
                              )
                            ]),
                            title: Text(
                              allAnnouncements[index].title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                            subtitle: !allAnnouncements[index]
                                    .viewedUserIds
                                    .contains(Provider.of<Auth>(context,
                                            listen: false)
                                        .myProfile
                                        .accountId)
                                ? Text(
                                    "(new)",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container(),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
  }

  readAllAnnouncement() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    final url =
        "authenticated/viewAllAnnouncements?userId=${profile.accountId}";
    var accessToken = Provider.of<Auth>(this.context).accessToken;
    final response = await ApiBaseHelper.instance
        .putProtected(url, accessToken: accessToken);
    await loadNotifications();
    print("Success");
  }

  deleteAllAnnouncement() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    final url =
        "authenticated/clearAllAnnouncementsForUser?userId=${profile.accountId}";
    var accessToken = Provider.of<Auth>(this.context).accessToken;
    final response = await ApiBaseHelper.instance
        .deleteProtected(url, accessToken: accessToken);
    await loadNotifications();
    print("Success");
  }
}
