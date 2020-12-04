import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/profileHelper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/screens/follow/followOverview.dart';
import 'package:matchub_mobile/screens/profile/wall_components/manageKahsScreen.dart';
import 'package:matchub_mobile/screens/profile/wall_components/manageOrganisationMembers.dart';
import 'package:matchub_mobile/screens/profile/wall_components/viewOrganisationMembers.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/services/manageOrganisationmembers.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:matchub_mobile/widgets/viewSdgTargets.dart';
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
  List<Profile> members = [];
  List<Profile> kahs = [];
  bool _isLoading = false;
  initState() {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    if (myProfile.isOrganisation) {
      loadMembers();
    }
  }

  toggleFollowing(int followId) async {
    Profile myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    try {
      var responseData;
      if (myProfile.following.indexOf(followId) != -1) {
        responseData = await ApiBaseHelper.instance.postProtected(
            "authenticated/unfollowProfile?unfollowId=${followId}&accountId=${myProfile.accountId}");
      } else {
        responseData = await ApiBaseHelper.instance.postProtected(
            "authenticated/followProfile?followId=${followId}&accountId=${myProfile.accountId}");
      }
      setState(() {});
    } catch (error) {
      print(error.toString());
      showErrorDialog(error.toString(), context);
    }
  }

  loadMembers() async {
    setState(() {
      _isLoading = false;
    });
    await Provider.of<ManageOrganisationMembers>(context, listen: false)
        .getMembers(widget.profile);

    await Provider.of<ManageOrganisationMembers>(context, listen: false)
        .getKahs(widget.profile);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    kahs = Provider.of<ManageOrganisationMembers>(context).listOfKah;
    members = Provider.of<ManageOrganisationMembers>(context).members;
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
                  icon: Icon(Icons.info_outline_rounded),
                  color: Colors.grey[850],
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return _isLoading
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildBadges(),
                                      buildKah(context),
                                      ...buildOrganisationMembers(
                                          context, members),
                                    ],
                                  ),
                                ),
                              );
                      },
                    );
                  })
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
                        style: TextStyle(fontSize: 20, color: kPrimaryColor),
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
                              style:
                                  TextStyle(fontSize: 20, color: kPrimaryColor),
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
                            style:
                                TextStyle(fontSize: 20, color: kPrimaryColor),
                          ),
                        ])),
              ),
            )
          ]),
          SizedBox(height: 10),
          Row(
            children: [
              if (widget.profile.accountId != myProfile.accountId) ...[
                SizedBox(width: 10),
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
                  child: Text("Contact",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
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
                      ? Text("Me",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))
                      : (myProfile.following.indexOf(widget.profile.accountId) >
                              -1)
                          ? Text(
                              "Unfollow",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Follow",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                )),
                SizedBox(width: 10),
              ],
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
                  if(widget.profile.city.isNotEmpty)  Text(
                    "${widget.profile.city}, ",
                    style: AppTheme.searchLight.copyWith(fontSize: 14),
                  ),
                  Text(
                    "${widget.profile.country}",
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
                  colorClickableText: kSecondaryColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: '\nshow less',
                ),
              ],
            ),
          ),
          if(widget.profile.skillSet.isNotEmpty) buildSkillset(),
          buildSDGTags(),
        ],
      ),
    );
  }

  Row buildSkillset() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text("Skillsets"),
              )),
          Flexible(
            flex: 3,
            child: Tags(
              horizontalScroll: true,
              itemCount: widget.profile.skillSet.length,
              itemBuilder: (int index) {
                return ItemTags(
                  alignment: MainAxisAlignment.center,
                  key: Key(index.toString()),
                  index: index,
                  title: widget.profile.skillSet[index],
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
              heightHorizontalScroll: 40,
              alignment: WrapAlignment.end,
              runAlignment: WrapAlignment.start,
            ),
          ),
        ]);
  }

  Widget buildSDGTags() {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) =>
              ViewSDGTargets(selectedTargets: widget.profile.selectedTargets))),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("SDG Interests")),
            ),
            Flexible(
              flex: 3,
              child: Tags(
                horizontalScroll: true,
                itemCount: widget.profile.sdgs.length, // required
                itemBuilder: (int index) {
                  return ItemTags(
                    key: Key(index.toString()),
                    index: index, // required
                    title: widget.profile.sdgs[index].sdgName,
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
                heightHorizontalScroll: 40,
                alignment: WrapAlignment.end,
                runAlignment: WrapAlignment.start,
              ),
            ),
          ]),
    );
  }

  Column buildKah(BuildContext context) {
    Profile currentUser = Provider.of<Auth>(context).myProfile;
    if (widget.profile.isOrganisation) {
      return Column(children: [
        Row(
          children: [
            Expanded(child: Text("Key Appointment Holders")),
            if (currentUser.accountId == widget.profile.accountId) ...[
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => ManageKahsScreen(
                                user: widget.profile,
                              )));
                },
                child: Text(
                  "Manage",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ]
          ],
        ),
        (kahs.isNotEmpty)
            ? Container(
                color: Colors.transparent,
                height: 80.0,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: kahs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        width: 100.0,
                        height: 50.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildAvatar(kahs[index], radius: 60),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(kahs[index].name,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 10))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(
                color: Colors.transparent,
                height: 18.0,
                child: Text(
                  "No Key appointment holders yet",
                  style:
                      TextStyle(color: Colors.blueGrey.shade200, fontSize: 10),
                ))
      ]);
    } else {
      return Column();
    }
  }

  buildOrganisationMembers(BuildContext context, List<Profile> members) {
    Profile currentUser = Provider.of<Auth>(context, listen: false).myProfile;
    List<Widget> organisationMembers = [
      SizedBox(height: 20),
    ];
    print(currentUser.name);
    if (widget.profile.isOrganisation) {
      organisationMembers.add(Row(
        children: [
          Expanded(child: Text("Organisation members")),
          if (currentUser.accountId == widget.profile.accountId) ...[
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ManageOrganisationMembersScreen(
                              user: widget.profile,
                            )));
              },
              child: Text(
                "Manage",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
          ]
        ],
      ));
      if (members.isNotEmpty) {
        organisationMembers.add(Container(
            height: 60,
            width: double.infinity,
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
                              offset: Offset(i * 30.0, 0),
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: buildAvatar(e, radius: 30)),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ViewOrganisationMembersScreen(
                                user: widget.profile)));
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
            )));
      } else {
        organisationMembers.add(Container(
            height: 18,
            color: Colors.transparent,
            child: Text(
              "No Members yet",
              style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 10),
            )));
      }
    }
    return organisationMembers;
  }

  buildBadges() {
    return widget.profile.badges.isNotEmpty
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Badges Earned",
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.profile.badges.length,
                itemBuilder: (_, index) {
                  return ClipOval(
                    child: Container(
                      height: 100,
                      child: Tooltip(
                        message: widget.profile.badges[index].badgeTitle,
                        child:
                            AttachmentImage(widget.profile.badges[index].icon),
                      ),
                    ),
                  );
                },
              ),
            ),
          ])
        : Container();
  }
}
