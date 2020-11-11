import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import '../../../sizeconfig.dart';

class Achievement extends StatefulWidget {
  @override
  _AchievementState createState() => _AchievementState();
}

class _AchievementState extends State<Achievement> {
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  Future load;
  Gamification gamification;
  Profile myProfile;

  @override
  void initState() {
    load = retrieveGamification();
    super.initState();
  }

  retrieveGamification() async {
    final url = 'authenticated/getPointTiers';
    final responseData = await _helper.getProtected(url);
    gamification = Gamification.fromJson(responseData);
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    return FutureBuilder(
      future: load,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Scaffold(
              body: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      "assets/images/leaderboard.JPG",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                      child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 30.0),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 20.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  height: 100,
                                                  color: AppTheme.project3
                                                      .withOpacity(0.8),
                                                  child: Row(
                                                    children: <Widget>[
                                                      myProfile.reputationPoints <
                                                              5
                                                          ? Container(
                                                              width: 50,
                                                              height: 70,
                                                              child: Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .lock_outline,
                                                                      size: 40,
                                                                      color: Colors
                                                                          .black)))
                                                          : Container(),
                                                      Container(
                                                          width: 50,
                                                          height: 70,
                                                          child: Center(
                                                            child: Text(
                                                              gamification
                                                                  .pointsToComment
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  color: AppTheme
                                                                      .project2),
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                          width: 100,
                                                          height: 70,
                                                          child: Center(
                                                            child: Text(
                                                              'points to comment',
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 20.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  height: 100,
                                                  color: AppTheme.project3
                                                      .withOpacity(0.8),
                                                  child: Row(
                                                    children: <Widget>[
                                                      myProfile.reputationPoints <
                                                              50
                                                          ? Container(
                                                              width: 50,
                                                              height: 70,
                                                              child: Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .lock_outline,
                                                                      size: 40,
                                                                      color: Colors
                                                                          .black)))
                                                          : Container(),
                                                      Container(
                                                          width: 50,
                                                          height: 70,
                                                          child: Center(
                                                            child: Text(
                                                              gamification
                                                                  .pointsToDownvote
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  color: AppTheme
                                                                      .project2),
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                          width: 100,
                                                          height: 70,
                                                          child: Center(
                                                            child: Text(
                                                              'points to downvote',
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 20.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  height: 100,
                                                  color: AppTheme.project3
                                                      .withOpacity(0.8),
                                                  child: Row(
                                                    children: <Widget>[
                                                      myProfile.reputationPoints <
                                                              100
                                                          ? Container(
                                                              width: 50,
                                                              height: 70,
                                                              child: Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .lock_outline,
                                                                      size: 40,
                                                                      color: Colors
                                                                          .black)))
                                                          : Container(),
                                                      Container(
                                                          width: 50,
                                                          height: 70,
                                                          child: Center(
                                                            child: Text(
                                                              gamification
                                                                  .pointsToAnonymousReview
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  color: AppTheme
                                                                      .project2),
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                          width: 100,
                                                          height: 70,
                                                          child: Center(
                                                            child: Text(
                                                              'points to review',
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 20.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  height: 100,
                                                  color: AppTheme.project3
                                                      .withOpacity(0.8),
                                                  child: Row(
                                                    children: <Widget>[
                                                      myProfile.reputationPoints <
                                                              200
                                                          ? Container(
                                                              width: 50,
                                                              height: 70,
                                                              child: Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .lock_outline,
                                                                      size: 40,
                                                                      color: Colors
                                                                          .black)))
                                                          : Container(),
                                                      Container(
                                                          width: 50,
                                                          height: 70,
                                                          child: Center(
                                                            child: Text(
                                                              gamification
                                                                  .pointsToSpotlight
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  color: AppTheme
                                                                      .project2),
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                          width: 100,
                                                          height: 70,
                                                          child: Center(
                                                            child: Text(
                                                              'points to spotlight',
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
