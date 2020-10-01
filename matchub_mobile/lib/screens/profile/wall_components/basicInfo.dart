import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/screens/follow/follow_overview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/database.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class BasicInfo extends StatefulWidget {
  Profile profile;
  Function follow;
  BasicInfo({this.profile, this.follow});

  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context).myProfile;

    return Container(
        margin: EdgeInsets.only(top: 20, right: 20, left: 20),
        width: 100 * SizeConfig.widthMultiplier,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(4, 6),
                blurRadius: 10,
                color: Colors.blueGrey.withOpacity(0.1),
              ),
              BoxShadow(
                offset: Offset(-4, -5),
                blurRadius: 10,
                color: Colors.blueGrey.withOpacity(0.1),
              ),
            ],
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                        height: 16 * SizeConfig.heightMultiplier,
                        width: 16 * SizeConfig.heightMultiplier,
                        child: AttachmentImage(widget.profile.profilePhoto)),
                  ),
                  Container(
                    width: 48 * SizeConfig.widthMultiplier,
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.profile.name}",
                          style: AppTheme.titleLight,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("Stakeholder", style: AppTheme.subTitleLight),
                        SizedBox(height: 10),
                        Container(
                            width: 36 * SizeConfig.widthMultiplier,
                            constraints: BoxConstraints(
                                minHeight: 8 * SizeConfig.heightMultiplier),
                            decoration: BoxDecoration(
                              color: Color(0xFF7B89A4).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Rep.",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          NumberFormat.compactCurrency(
                                                  decimalDigits: 0, symbol: '')
                                              .format(widget
                                                  .profile.reputationPoints),
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  )),
                              Flexible(
                                fit: FlexFit.tight,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(
                                        FollowOverviewScreen.routeName,
                                        arguments: {
                                          "profile": widget.profile,
                                          "initialTab": 0
                                        },
                                      );
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Followers",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              Text(
                                                NumberFormat.compactCurrency(
                                                        decimalDigits: 0,
                                                        symbol: '')
                                                    .format(widget.profile
                                                        .followers.length),
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ]))),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(
                                            FollowOverviewScreen.routeName,
                                            arguments: {
                                          "profile": widget.profile,
                                          "initialTab": 1
                                        });
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Following",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Text(
                                              NumberFormat.compactCurrency(
                                                      decimalDigits: 0,
                                                      symbol: '')
                                                  .format(widget.profile
                                                      .following.length),
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ])),
                                ),
                              )
                            ])),
                      ],
                    ),
                  )
                ]),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                    child: OutlineButton(
                  onPressed: () async {
                    if (!await DatabaseMethods().checkChatRoomExists(
                        myProfile.uuid, widget.profile.uuid)) {
                      DatabaseMethods().addChatRoom({
                        "createdAt": DateTime.now(),
                        "createdBy": myProfile.uuid,
                        "members": [myProfile.uuid, widget.profile.uuid]
                          ..sort(),
                      });
                    }
                    String chatRoomId = await DatabaseMethods().getChatRoomId(myProfile.uuid, widget.profile.uuid);
                    print(chatRoomId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Messages(chatRoomId: chatRoomId, recipient: widget.profile
                                )));
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  child: Text("Contact"),
                )),
                if (widget.profile.accountId != myProfile.accountId) ...[
                  SizedBox(width: 10),
                  Expanded(
                      child: OutlineButton(
                    color: (widget.profile.accountId == myProfile.accountId)
                        ? kSecondaryColor
                        : (myProfile.following
                                    .indexOf(widget.profile.accountId) >
                                -1)
                            ? Colors.grey[200]
                            : kAccentColor,
                    onPressed: () {
                      if (widget.profile.accountId == myProfile.accountId)
                        return null;
                      widget.follow(widget.profile.accountId);
                      setState(() => print(widget.profile.accountId));
                      myProfile.toggleFollow(widget.profile.accountId);
                      print(myProfile.following);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    child: (widget.profile.accountId == myProfile.accountId)
                        ? Text("Me")
                        : (myProfile.following
                                    .indexOf(widget.profile.accountId) >
                                -1)
                            ? Text("Unfollow")
                            : Text("Follow"),
                  ))
                ],
                SizedBox(width: 10),
                Expanded(
                    child: OutlineButton(
                  onPressed: () {
                    Share.share(
                        'Hey there! Ever heard of the United Nation\'s Sustainable Development Goals?\nCheck out this profile, he\'s been doing great work!\nhttp://localhost:3000/profile/${widget.profile.uuid}');
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  child: Text("Share"),
                ))
              ],
            )
          ],
        ));
  }
}
