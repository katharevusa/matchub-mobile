import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';

class DescriptionInfo extends StatelessWidget {
  Individual profile;

  DescriptionInfo({this.profile});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
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
                    Text("${profile.city}, ", style: AppTheme.subTitleLight),
                  Text("${profile.country}", style: AppTheme.subTitleLight)
                ],
              ),
            SizedBox(height: 10),
            buildSDGTags(),
            SizedBox(height: 10),
            buildSkillset(),
            SizedBox(height: 10),
            buildProfileUrl(),
            SizedBox(height: 10),
            Column(
              children: [
                Row(
                  children: [Expanded(child: Text("Description"))],
                ),
                Row(
                  children: [Expanded(child: Text(profile.profileDescription,
                    style: AppTheme.unSelectedTabLight))],
                )
              ],
            )
          ],
        ));
  }

  Column buildProfileUrl() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text("Profile Page Url"))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Text("${profile.profileUrl}",
                    style: AppTheme.unSelectedTabLight)),
          ],
        )
      ],
    );
  }

  Row buildSkillset() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
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
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
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
