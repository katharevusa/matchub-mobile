import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/notification/announcementDetail.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class InboxNotification extends StatefulWidget {
  @override
  _InboxNotificationState createState() => _InboxNotificationState();
}

class _InboxNotificationState extends State<InboxNotification> {
  List<Announcement> allAnnouncements = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  Future allAnnouncementsFuture;
  Profile user;

  @override
  void didChangeDependencies() {
    user = Provider.of<Auth>(context).myProfile;
    allAnnouncementsFuture = getAllAnnouncements();
    super.didChangeDependencies();
  }

  getAllAnnouncements() async {
    final url =
        'authenticated/getAnnouncementsByUserId?userId=${user.accountId}';
    final responseData = await _apiHelper.getWODecode(
        url, Provider.of<Auth>(this.context, listen: false).accessToken);
    (responseData as List)
        .forEach((e) => allAnnouncements.add(Announcement.fromJson(e)));
    print(allAnnouncements.length);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: allAnnouncementsFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? ListView.builder(
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
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            Text(
                              DateFormat('E')
                                  .format(allAnnouncements[index].timestamp),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            Text(
                              allAnnouncements[index].timestamp.day.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              DateFormat('MMM')
                                  .format(allAnnouncements[index].timestamp),
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 10),
                            )
                          ]),
                          Text(
                            allAnnouncements[index].title,
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
          : Center(child: CircularProgressIndicator()),
    );
  }
}
