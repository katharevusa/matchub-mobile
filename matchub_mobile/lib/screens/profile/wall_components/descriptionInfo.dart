import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/wall_components/manageKahsScreen.dart';
import 'package:matchub_mobile/screens/profile/wall_components/manageOrganisationMembers.dart';
import 'package:matchub_mobile/screens/profile/wall_components/viewOrganisationMembers.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class DescriptionInfo extends StatefulWidget {
  Profile profile;
  DescriptionInfo({this.profile});

  @override
  _DescriptionInfoState createState() => _DescriptionInfoState();
}

class _DescriptionInfoState extends State<DescriptionInfo> {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<Profile> members;
  List<Profile> kahs;
  Future membersFuture;
  Future kahsFuture;

  @override
  void initState() {
    super.initState();
    membersFuture = getMembers();
    kahsFuture = getKah();
  }

  getMembers() async {
    final url =
        'authenticated/organisation/viewMembers/${widget.profile.accountId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(this.context, listen: false).accessToken);
    members = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }

  getKah() async {
    final url =
        'authenticated/organisation/viewKAHs/${widget.profile.accountId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(this.context, listen: false).accessToken);
    kahs = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([membersFuture, kahsFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: EdgeInsets.all(20),
                  // height: 29 * SizeConfig.heightMultiplier,
                  width: 100 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(4, 3),
                          blurRadius: 10,
                          color: kSecondaryColor.withOpacity(0.1),
                        ),
                        BoxShadow(
                          offset: Offset(-4, -3),
                          blurRadius: 10,
                          color: kSecondaryColor.withOpacity(0.1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.profile.country != null)
                        Row(
                          children: [
                            Expanded(child: Text("Based In")),
                            if (widget.profile.city != null)
                              Text("${widget.profile.city ?? 'No Data'}, ",
                                  style: AppTheme.subTitleLight),
                            Text("${widget.profile.country ?? 'No Data'}",
                                style: AppTheme.subTitleLight)
                          ],
                        ),
                      SizedBox(height: 20),
                      buildSDGTags(),
                      SizedBox(height: 20),
                      buildSkillset(),
                      SizedBox(height: 20),
                      buildProfileUrl(),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            children: [Expanded(child: Text("Description"))],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      widget.profile.profileDescription ??
                                          'No Data',
                                      style: AppTheme.unSelectedTabLight))
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      //return this only if it is organisation user
                      buildKah(context),
                      SizedBox(height: 20),
                      buildOrganisationMembers(context, members),
                    ],
                  ))
              : Center(child: CircularProgressIndicator()),
    );
  }

  Column buildOrganisationMembers(BuildContext context, List<Profile> members) {
    Profile currentUser = Provider.of<Auth>(context).myProfile;

    print(currentUser.name);
    if (widget.profile.isOrgnisation) {
      if (members.isNotEmpty) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: Text("Organisation members")),
                if (currentUser.accountId == widget.profile.accountId) ...[
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  ManageOrganisationMembersScreen(
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
            SizedBox(height: 20),
            Container(
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
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  ViewOrganisationMembersScreen(
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
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: Text("Organisation members")),
                if (currentUser.accountId == widget.profile.accountId) ...[
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  ManageOrganisationMembersScreen(
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
            SizedBox(height: 20),
            Container(
                height: 18,
                color: Colors.transparent,
                child: Text(
                  "No Members yet",
                  style:
                      TextStyle(color: Colors.blueGrey.shade200, fontSize: 10),
                ))
          ],
        );
      }
    } else {
      return Column();
    }
  }

  Widget _buildAvatar(Profile profile, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: ClipOval(
        child: AttachmentImage(profile.profilePhoto),
      ),
    );
  }

  Column buildKah(BuildContext context) {
    Profile currentUser = Provider.of<Auth>(context).myProfile;
    if (widget.profile.isOrgnisation) {
      if (kahs.isNotEmpty) {
        return Column(children: [
          Row(
            children: [
              Expanded(child: Text("Key Appointment Holder")),
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
          SizedBox(height: 20),
          Container(
            color: Colors.transparent,
            height: 150.0,
            // padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: kahs.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  // onTap: () => Navigator.push(
                  //     context,
                  //     new MaterialPageRoute(
                  //         builder: (context) => ProjectDetailOverview())),
                  child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      width: 100.0,
                      height: 50.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipOval(
                            child: AttachmentImage(kahs[index].profilePhoto),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(kahs[index].name,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 10))
                        ],
                      )),
                );
              },
            ),
          )
        ]);
      } else {
        return Column(children: [
          Row(
            children: [
              Expanded(child: Text("Key Appointment Holder")),
              if (currentUser.accountId == widget.profile.accountId) ...[
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                ManageKahsScreen(user: widget.profile)));
                  },
                  child: Text(
                    "Manage",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ]
            ],
          ),
          SizedBox(height: 20),
          Container(
              color: Colors.transparent,
              height: 18.0,
              // padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "No Key appointment holders yet",
                style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 10),
              ))
        ]);
      }
    } else {
      return Column();
    }
  }

  Column buildProfileUrl() {
    return Column(
      children: [
        Row(
          children: [Expanded(child: Text("Profile Page Url"))],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Text("www.linkedin.com" ?? 'No Data',
                    style: AppTheme.unSelectedTabLight)),
          ],
        )
      ],
    );
  }

  Row buildSkillset() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 1, child: Text("Skillset")),
          Flexible(
            flex: 3,
            child: Tags(
              itemCount: widget.profile.skillSet.length, // required
              itemBuilder: (int index) {
                return ItemTags(
                  // Each ItemTags must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: Key(index.toString()),
                  index: index, // required
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
              alignment: WrapAlignment.end,
              runAlignment: WrapAlignment.start,
              spacing: 6,
              runSpacing: 6,
            ),
          ),
        ]);
  }

  Row buildSDGTags() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 1, child: Text("SDG Interests")),
          Flexible(
            flex: 3,
            child: Tags(
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
              alignment: WrapAlignment.end,
              runAlignment: WrapAlignment.start,
              spacing: 6,
              runSpacing: 6,
            ),
          ),
        ]);
  }
}
