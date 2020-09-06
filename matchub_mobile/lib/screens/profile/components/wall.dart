import 'package:flutter/material.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';

class Wall extends StatelessWidget {
  Individual profile;

  Wall({this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8 * SizeConfig.widthMultiplier),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 20),
        Text("Activity", style: AppTheme.titleLight),
        SizedBox(height: 10),
        ListView.separated(
          separatorBuilder: (ctx, index) => Divider(
            height: 40,
            thickness: 1 
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(profile.profilePhoto),
                ),
                title: Text("${profile.lastName} ${profile.firstName}"),
                subtitle: Text(
                    "${profile.posts[index].comments.length} comments | ${profile.posts[index].likes} likes"),
                trailing: Text(
                    DateTime.now().differenceFrom(
                      profile.posts[index].timeCreated,
                    ),
                    style: AppTheme.unSelectedTabLight),
              ),
              SizedBox(height: 10),
              Text("${profile.posts[index].content}",
                  style: AppTheme.unSelectedTabLight),
            ],
          ),
          itemCount: profile.posts.length,
        )
      ]),
    );
  }
}
