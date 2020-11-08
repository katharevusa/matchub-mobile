import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';

import 'package:matchub_mobile/screens/home/components/greeting_card.dart';
import 'package:matchub_mobile/screens/home/leaderboard&achievement/award.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class Ranking extends StatelessWidget {
  Profile myProfile;
  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    return Stack(
      overflow: Overflow.visible,
      fit: StackFit.passthrough,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                settings: RouteSettings(name: "/notifications"),
                builder: (_) => Award()));
          },
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 10, horizontal: 4 * SizeConfig.widthMultiplier),
            height: 18 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      AppTheme.topBarBackgroundColor,
                      AppTheme.topBarBackgroundColor,
                      // AppTheme.project2,
                    ])),
            // alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 4 * SizeConfig.heightMultiplier,
                  left: 8 * SizeConfig.widthMultiplier),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("#53",
                      style: TextStyle(
                        color: AppTheme.selectedTabBackgroundColor,
                        fontWeight: FontWeight.w800,
                        fontSize: SizeConfig.heightMultiplier * 5,
                      )),
                  myProfile.isOrganisation
                      ? Text("in Organisation ranking",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.heightMultiplier * 2,
                          ))
                      : Text("in Individual ranking",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.heightMultiplier * 2,
                          )),
                  SizedBox(height: 10),
                  Text("View Achievement >>",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      )),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 30,
          child: Container(
            height: 136,
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/images/medal.png",
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 57,
          child: Container(
            height: 78,
            width: 78,
            child: ClipOval(
              child: SizedBox(
                  height: 16 * SizeConfig.heightMultiplier,
                  width: 16 * SizeConfig.widthMultiplier,
                  child: AttachmentImage(myProfile.profilePhoto)),
            ),
          ),
        ),
      ],
    );
  }
}
