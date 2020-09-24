import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/components/viewOrganisationMembers.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:path/path.dart';

class DescriptionInfo extends StatelessWidget {
  Profile profile;
  final List<Map> collections = [
    {"title": "Tan Wee Kee", "image": './././assets/images/pancake.jpg'},
    {"title": "Tan Wek Kek", "image": './././assets/images/fries.jpg'},
    {"title": "Tan Wee Kek", "image": './././assets/images/fishtail.jpg'},
    {"title": "Tan Wee Kok", "image": './././assets/images/kathmandu1.jpg'},
  ];
  List<String> avatars = [
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F4.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F6.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F7.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fdev_damodar.jpg?alt=media&token=aaf47b41-3485-4bab-bcb6-2e472b9afee6',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fdev_sudip.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fdev_sid.png?alt=media',
  ];
  DescriptionInfo({this.profile});
  @override
  Widget build(BuildContext context) {
    return Container(
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
            if (profile.country != null)
              Row(
                children: [
                  Expanded(child: Text("Based In")),
                  if (profile.city != null)
                    Text("${profile.city ?? 'No Data'}, ",
                        style: AppTheme.subTitleLight),
                  Text("${profile.country ?? 'No Data'}",
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
                        child: Text(profile.profileDescription ?? 'No Data',
                            style: AppTheme.unSelectedTabLight))
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            //return this only if it is organisation user
            buildKah(context),
            SizedBox(height: 20),
            buildOrganisationMembers(context),
          ],
        ));
  }

  Column buildOrganisationMembers(BuildContext context) {
    if (profile.isOrgnisation) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("Organisation members")),
              FlatButton(
                onPressed: () {},
                child: Text(
                  "Manage",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
          Container(
            height: 60,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    ...avatars
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
                    // Navigator.of(context, rootNavigator: true)
                    // .push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         ViewOrganisationMembersScreem(user:profile)));
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ViewOrganisationMembersScreen(
                                user: profile, option: 0)));
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
      return Column();
    }
  }

  CircleAvatar _buildAvatar(String image, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: CircleAvatar(
        radius: radius - 2,
        backgroundImage: NetworkImage(image),
      ),
    );
  }

  Column buildKah(BuildContext context) {
    if (profile.isOrgnisation) {
      return Column(children: [
        Row(
          children: [
            Expanded(child: Text("Key Appointment Holder")),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ViewOrganisationMembersScreen(
                            user: profile, option: 1)));
              },
              child: Text(
                "Manage",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
        Container(
          color: Colors.transparent,
          height: 150.0,
          // padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: collections.length,
            itemBuilder: (BuildContext context, int index) {
              return Material(
                  child: InkWell(
                // onTap: () => Navigator.push(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (context) => ProjectDetailOverview())),
                child: Container(
                    color: Colors.transparent,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    width: 100.0,
                    height: 50.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(width: 3, color: Colors.blueGrey),
                            image: DecorationImage(
                                image: AssetImage(
                                  collections[index]['image'],
                                ),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(collections[index]['title'],
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 10))
                      ],
                    )),
              ));
            },
          ),
        )
      ]);
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
              itemCount: profile.skillSet.length, // required
              itemBuilder: (int index) {
                return ItemTags(
                  // Each ItemTags must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: Key(index.toString()),
                  index: index, // required
                  title: profile.skillSet[index],
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
              itemCount: profile.sdgs.length, // required
              itemBuilder: (int index) {
                return ItemTags(
                  key: Key(index.toString()),
                  index: index, // required
                  title: profile.sdgs[index].sdgName,
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
