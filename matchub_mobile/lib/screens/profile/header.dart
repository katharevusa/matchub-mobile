import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/profile_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/screens/follow/follow_overview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';

class ProfileHeader extends StatefulWidget {
  ProfileHeader({this.profile});
  Profile profile;

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Profile myProfile;

  toggleFollowing(int followId) async {
    Profile myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    try {
      var responseData;
      if (myProfile.following.indexOf(followId) != -1) {
        responseData = await ApiBaseHelper.instance.postProtected(
            "authenticated/unfollowProfile?unfollowId=${followId}&accountId=${myProfile.accountId}",
            accessToken: Provider.of<Auth>(context, listen: false).accessToken);
      } else {
        responseData = await ApiBaseHelper.instance.postProtected(
            "authenticated/followProfile?followId=${followId}&accountId=${myProfile.accountId}",
            accessToken: Provider.of<Auth>(context, listen: false).accessToken);
      }
      setState(() {});
    } catch (error) {
      print(error.toString());
      showErrorDialog(error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              ClipOval(
                child: buildAvatar(widget.profile,
                    radius: 70, borderColor: Colors.grey[200]),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${widget.profile.name}",
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                  iconSize: 24,
                  icon: Icon(Icons.more_vert_rounded),
                  color: Colors.grey[850],
                  onPressed: () {})
            ],
          ),
          SizedBox(height: 10),
          Row(children: [
            Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.all(1.25 * SizeConfig.widthMultiplier),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Reputation Pts",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        NumberFormat.compactCurrency(
                                decimalDigits: 0, symbol: '')
                            .format(widget.profile.reputationPoints),
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                )),
            Flexible(
              fit: FlexFit.tight,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      FollowOverviewScreen.routeName,
                      arguments: {"profile": widget.profile, "initialTab": 0},
                    );
                  },
                  child: Padding(
                      padding:
                          EdgeInsets.all(1.25 * SizeConfig.widthMultiplier),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Followers",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              NumberFormat.compactCurrency(
                                      decimalDigits: 0, symbol: '')
                                  .format(widget.profile.followers.length),
                              style: TextStyle(fontSize: 17),
                            ),
                          ]))),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                      FollowOverviewScreen.routeName,
                      arguments: {"profile": widget.profile, "initialTab": 1});
                },
                child: Padding(
                    padding: EdgeInsets.all(1.25 * SizeConfig.widthMultiplier),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Following",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            NumberFormat.compactCurrency(
                                    decimalDigits: 0, symbol: '')
                                .format(widget.profile.following.length),
                            style: TextStyle(fontSize: 17),
                          ),
                        ])),
              ),
            )
          ]),
          SizedBox(height: 10),
          Row(
            children: [
              if (widget.profile.accountId != myProfile.accountId) ...[
                Expanded(
                    child: OutlineButton(
                  borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                  onPressed: () async {
                    if (!await DatabaseMethods().checkChatRoomExists(
                        myProfile.uuid, widget.profile.uuid)) {
                      DatabaseMethods().addChatRoom({
                        "createdAt": DateTime.now(),
                        "createdBy": myProfile.uuid,
                        "members": [myProfile.uuid, widget.profile.uuid]
                          ..sort(),
                        "recentMessage": {}
                      });
                    }
                    String chatRoomId = await DatabaseMethods()
                        .getChatRoomId(myProfile.uuid, widget.profile.uuid);
                    print(chatRoomId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Messages(
                                chatRoomId: chatRoomId,
                                recipient: widget.profile)));
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  child: Text("Contact"),
                )),
                SizedBox(width: 10),
                Expanded(
                    child: OutlineButton(
                  borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                  color: (widget.profile.accountId == myProfile.accountId)
                      ? kSecondaryColor
                      : (myProfile.following.indexOf(widget.profile.accountId) >
                              -1)
                          ? Colors.grey[200]
                          : kAccentColor,
                  onPressed: () {
                    if (widget.profile.accountId == myProfile.accountId)
                      return null;
                    toggleFollowing(widget.profile.accountId);
                    setState(() => print(widget.profile.accountId));
                    myProfile.toggleFollow(widget.profile.accountId);
                    print(myProfile.following);
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  child: (widget.profile.accountId == myProfile.accountId)
                      ? Text("Me")
                      : (myProfile.following.indexOf(widget.profile.accountId) >
                              -1)
                          ? Text("Unfollow")
                          : Text("Follow"),
                )),
                SizedBox(width: 10),
              ],
              Expanded(
                  child: OutlineButton(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                onPressed: () {
                  Share.share(
                      'Hey there! Ever heard of the United Nation\'s Sustainable Development Goals?\nCheck out this profile, he\'s been doing great work!\nhttp://localhost:3000/profile/${widget.profile.uuid}');
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Text("Share"),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.grey[850],
                    size: 18,
                  ),
                  SizedBox(width: 2),
                  Text(
                    "${widget.profile.city}, ${widget.profile.country}",
                    style: AppTheme.searchLight.copyWith(fontSize: 14),
                  )
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Icon(
                    Icons.public,
                    color: Colors.grey[850],
                    size: 18,
                  ),
                  SizedBox(width: 2),
                  Text(
                    "www.linkedin.com",
                    style: AppTheme.searchLight.copyWith(fontSize: 14),
                  ),
                ]),
                SizedBox(height: 8),
                ReadMoreText(
                  widget.profile.profileDescription,
                  trimLines: 3,
                  style: TextStyle(
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.justify,
                  colorClickableText: kSecondaryColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: '\nshow less',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
