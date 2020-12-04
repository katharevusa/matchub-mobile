import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profileScreen.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class OrganisationLeaderboard extends StatefulWidget {
  @override
  _OrganisationLeaderboardState createState() =>
      _OrganisationLeaderboardState();
}

class _OrganisationLeaderboardState extends State<OrganisationLeaderboard> {
  List<Profile> organisations = [];
  Future organisationsFuture;
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  @override
  void initState() {
    organisationsFuture = getOrganisations();
    super.initState();
  }

  getOrganisations() async {
    final url = 'authenticated/organisationalLeaderboard';
    final responseData = await _helper.getProtected(
      url,
    );
    organisations = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: organisationsFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Scaffold(
              body: Stack(
                children: <Widget>[
                  // Container(
                  //   width: double.infinity,
                  //   height: double.infinity,
                  //   child: Image.asset(
                  //     "assets/images/leaderboard.JPG",
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  Positioned(
                  top: 10,
                  left: 130,
                    child: Container(
                        height: 100,
                        width: 150,
                        child: Text(
                          "Best Champions",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 27),
                        )),
                  ),
                  Positioned(
                  top: 120,
                  left: 30,
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: ClipOval(
                            child: SizedBox(
                                height: 16 * SizeConfig.heightMultiplier,
                                width: 16 * SizeConfig.widthMultiplier,
                                child: AttachmentImage(
                                    organisations[1].profilePhoto)),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          child: Text(
                            organisations[1].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                  top: 120,
                  left: 30,
                    child: Container(
                      height: 30,
                      width: 20,
                      child: Image.asset(
                        "assets/images/silver.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                  top: 90,
                  left: 155,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: ClipOval(
                            child: SizedBox(
                                height: 16 * SizeConfig.heightMultiplier,
                                width: 16 * SizeConfig.widthMultiplier,
                                child: AttachmentImage(
                                    organisations[0].profilePhoto)),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: Text(
                            organisations[0].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                  top: 90,
                  left: 155,
                    child: Container(
                      height: 30,
                      width: 20,
                      child: Image.asset(
                        "assets/images/gold.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                  top: 130,
                  right: 30,
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: ClipOval(
                            child: SizedBox(
                                height: 16 * SizeConfig.heightMultiplier,
                                width: 16 * SizeConfig.widthMultiplier,
                                child: AttachmentImage(
                                    organisations[2].profilePhoto)),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          child: Text(
                            organisations[2].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                  top: 130,
                  right: 30,
                    child: Container(
                      height: 30,
                      width: 20,
                      child: Image.asset(
                        "assets/images/bronze.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                      child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 250,
                      ),
                      Expanded(
                        child: Container(
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(20.0),
                          //     color: AppTheme.project4.withOpacity(0.2)),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 30.0),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 5),
                                        itemBuilder: (context, index) =>
                                            Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 20.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      child: Container(
                                                        height: 70,
                                                        color: AppTheme.project4
                                                            .withOpacity(0.6),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                                width: 50,
                                                                height: 70,
                                                                child: Center(
                                                                  child: Text(
                                                                    '#' +
                                                                        (index +
                                                                                1)
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                )),
                                                            Container(
                                                              height: 50,
                                                              width: 50,
                                                              child: ClipOval(
                                                                child: SizedBox(
                                                                    height: 16 *
                                                                        SizeConfig
                                                                            .heightMultiplier,
                                                                    width: 16 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    child: AttachmentImage(
                                                                        organisations[index]
                                                                            .profilePhoto)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Container(
                                                              width: 160,
                                                              child: Text(
                                                                  organisations[
                                                                          index]
                                                                      .name,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15)),
                                                            ),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text('Rep',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15)),
                                                                Text(
                                                                    organisations[
                                                                            index]
                                                                        .reputationPoints
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: AppTheme
                                                                            .project2,
                                                                        fontSize:
                                                                            15)),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                        itemCount: organisations.length,
                                      ),
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
