import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class BadgeCreation extends StatefulWidget {
  Map<String, dynamic> project;
  BadgeCreation(this.project);

  @override
  _BadgeCreationState createState() => _BadgeCreationState();
}

class _BadgeCreationState extends State<BadgeCreation> {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<String> badgesIcon;
  /*Retrieve a list of project badges */
  // Map<String,dynamic> badge;
  // Badge badge = new Badge;
  TextEditingController _badgeTitleController = new TextEditingController();
  getAllProjectBadgeIcons() async {
    final url = 'authenticated/getProjectBadgeIcons';
    final response = await _helper.getWODecode(
            url, Provider.of<Auth>(this.context, listen: false).accessToken)
        as List;
    badgesIcon = List<String>.from(response);
  }

  createProjectBadge() async {
//create badge here
  }

  @override
  Widget build(BuildContext context) {
    // _badgeTitleController.text = badgeMap.title
    getAllProjectBadgeIcons();
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: TextField(
          decoration: InputDecoration(hintText: 'Badge Title'),
          controller: _badgeTitleController,
          autofocus: true,
          onChanged: (text) {
            // widget.project["projectDescription"] = text;
          },
        ),
      ),
      Text("Please select your badge icon"),
      Container(
        color: Colors.white,
        height: 200.0,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: badgesIcon.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
                child: InkWell(
              onTap: () => {
                //select the project badge, set it to badgeMap.icon
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  width: 150.0,
                  height: 200.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                child: AttachmentImage(badgesIcon[index]),
                              ))),
                    ],
                  )),
            ));
          },
        ),
      ),
    ]);
  }
}
