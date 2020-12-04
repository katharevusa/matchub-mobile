import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/home/competition/viewAllCompetition.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';

class ViewCompetition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            settings: RouteSettings(name: "/view-all-competition"),
            builder: (_) => ViewAllCompetition()));
      },
      child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: 4 * SizeConfig.widthMultiplier),
          height: 5 * SizeConfig.heightMultiplier,
          width: 100 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppTheme.project4,
                    AppTheme.topBarBackgroundColor,
                    // AppTheme.project2,
                  ])),
          child: Center(
              child: Text(
            "Join Competition>>",
            style: TextStyle(color: Colors.white),
          ))),
    );
  }
}
