import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class PManagementProjectFollowers extends StatelessWidget {
  Project project;
  PManagementProjectFollowers(this.project);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 180,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Project Followers",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          project.userFollowers.isNotEmpty
              ? Stack(
                  children: [
                    ...buildProjectFollowers(context, project.userFollowers),
                  ],
                )
              : Column(
                  children: [
                    Text(
                      "0 Followers...",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Container(
                      height: 60,
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        "assets/images/Empty-pana.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  buildProjectFollowers(BuildContext context, List userFollowers) {
    List<Widget> members = [];
    var l = userFollowers.length;
    if (userFollowers.length > 5) {
      userFollowers = userFollowers.sublist(0, 5);
    }
    members.add(Container(
      height: 30,
      width: 180,
      color: Colors.transparent,
      child: Stack(
        children: [
          ...userFollowers
              .asMap()
              .map(
                (i, e) => MapEntry(
                  i,
                  Transform.translate(
                    offset: Offset(i * 20.0, 0),
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
    ));
    members.add(
      Positioned(
        right: 10,
        bottom: 0,
        child: Container(
          height: 10,
          child: l - userFollowers.length != 0
              ? Text(
                  (l - userFollowers.length).toString() + ' more...',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 10),
                )
              : Container(),
        ),
      ),
    );
    return members;
  }

  Widget _buildAvatar(TruncatedProfile e, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: CircleAvatar(
        radius: radius - 2,
        backgroundImage: NetworkImage(
            "${ApiBaseHelper().baseUrl}${e.profilePhoto.substring(30)}"),
      ),
    );
  }
}
