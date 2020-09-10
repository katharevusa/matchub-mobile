import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widget/attachment_image.dart';
import 'package:provider/provider.dart';

class BasicInfo extends StatelessWidget {
  Individual profile;
  
  BasicInfo({this.profile});
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: 35 * SizeConfig.heightMultiplier,
      child: Stack(
        children: [
          // Container(
          //     height: 20 * SizeConfig.heightMultiplier,
          //     decoration: BoxDecoration(
          //         color: Color(0xFF7B89A4),
          //         borderRadius: BorderRadius.only(
          //             bottomLeft: Radius.circular(30.0),
          //             bottomRight: Radius.circular(30.0)))),
          Container(
              margin: EdgeInsets.only(top: 30, right: 20, left: 20),
              width: 100 * SizeConfig.widthMultiplier,
              padding: EdgeInsets.all(20),
              height: 29 * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(4, 6),
                      blurRadius: 10,
                      color: Colors.blueGrey.withOpacity(0.2),
                    ),
                    BoxShadow(
                      offset: Offset(-4, -5),
                      blurRadius: 10,
                      color: Colors.blueGrey.withOpacity(0.2),
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
                              child: AttachmentImage(profile.profilePhoto)),
                        ),
                        Container(
                          height: 16 * SizeConfig.heightMultiplier,
                          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${profile.firstName} ${profile.lastName}",
                                style: AppTheme.titleLight,
                              ),
                              Text("Individual", style: AppTheme.subTitleLight),
                              SizedBox(height: 10),
                              Container(
                                  width: 44 * SizeConfig.widthMultiplier,
                                  height: 7 * SizeConfig.heightMultiplier,
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
                                                        decimalDigits: 0,
                                                        symbol: '')
                                                    .format(
                                                        profile.reputationPoints),
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Followers",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  Text(
                                                    NumberFormat
                                                            .compactCurrency(
                                                                decimalDigits:
                                                                    0,
                                                                symbol: '')
                                                        .format(profile
                                                            .followers.length),
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ]))),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Following",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                Text(
                                                  NumberFormat.compactCurrency(
                                                          decimalDigits: 0,
                                                          symbol: '')
                                                      .format(profile
                                                          .following.length),
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                ),
                                              ])),
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
                        onPressed: () {},
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        child: Text("Contact"),
                      )),
                      SizedBox(width: 10),
                      Expanded(
                          child: OutlineButton(
                        onPressed: () {},
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        child: Text("Edit"),
                      ))
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
