import 'package:flutter/material.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';

class Wall extends StatelessWidget {
  Individual profile;

  Wall({this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8* SizeConfig.widthMultiplier),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 20),
        Text("Activity", style: AppTheme.titleLight),
        SizedBox(height: 10),
        ListView.separated(
          separatorBuilder: (ctx, index) => Divider(),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(profile.profilePhoto),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                      child: Text("${profile.lastName} ${profile.firstName}")),
                ],
              ),
              SizedBox(height: 15),
              Text("${profile.posts[index].content}"),
            ],
          ),
          itemCount: profile.posts.length,
        )
      ]),
    );
  }
}
