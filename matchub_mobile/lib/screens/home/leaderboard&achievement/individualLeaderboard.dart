import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class IndividialLeaderboard extends StatefulWidget {
  @override
  _IndividialLeaderboardState createState() => _IndividialLeaderboardState();
}

class _IndividialLeaderboardState extends State<IndividialLeaderboard> {
  List<Profile> individuals = [];
  Future individualsFuture;
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  @override
  void initState() {
    individualsFuture = getIndividuals();
    super.initState();
  }

  getIndividuals() async {
    final url = 'authenticated/individualLeaderboard';
    final responseData = await _helper.getProtected(
      url,
    );
    individuals = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: individualsFuture,
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
                  Positioned(
                    top: 100,
                    left: 110,
                    child: Container(
                        height: 100,
                        width: 150,
                        child: Text(
                          "Best Champions",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 27),
                        )),
                  ),
                  // Positioned(
                  //   top: 220,
                  //   left: 100,
                  //   child: Container(
                  //     height: 30,
                  //     width: 20,
                  //     child: Image.asset(
                  //       "assets/images/silver.png",
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    top: 230,
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
                                    individuals[1].profilePhoto)),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          child: Text(
                            individuals[1].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   top: 180,
                  //   left: 215,
                  //   child: Container(
                  //     height: 30,
                  //     width: 20,
                  //     child: Image.asset(
                  //       "assets/images/gold.png",
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    top: 185,
                    right: 135,
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
                                    individuals[0].profilePhoto)),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: Text(
                            individuals[0].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   top: 220,
                  //   right: 20,
                  //   child: Container(
                  //     height: 30,
                  //     width: 20,
                  //     child: Image.asset(
                  //       "assets/images/bronze.png",
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    top: 230,
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
                                    individuals[2].profilePhoto)),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          child: Text(
                            individuals[2].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white),
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
                                                        color: AppTheme.project3
                                                            .withOpacity(0.3),
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
                                                                        individuals[index]
                                                                            .profilePhoto)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                                individuals[
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
                                                                    individuals[
                                                                            index]
                                                                        .reputationPoints
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: AppTheme
                                                                            .project5,
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
                                        itemCount: individuals.length,
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
              /*  SingleChildScrollView(
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        color: Colors.blue.shade200,
                      ),
                      width: double.infinity,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 90, bottom: 20),
                      width: 299,
                      height: 230,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(160),
                              bottomLeft: Radius.circular(290),
                              bottomRight: Radius.circular(160),
                              topRight: Radius.circular(10))),
                    ),
                    Positioned(
                      top: 70,
                      left: 30,
                      child: Container(
                        height: 78,
                        width: 78,
                        child: ClipOval(
                          child: SizedBox(
                              height: 16 * SizeConfig.heightMultiplier,
                              width: 16 * SizeConfig.widthMultiplier,
                              child:
                                  AttachmentImage(individuals[1].profilePhoto)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 135,
                      child: Container(
                        height: 78,
                        width: 78,
                        child: ClipOval(
                          child: SizedBox(
                              height: 16 * SizeConfig.heightMultiplier,
                              width: 16 * SizeConfig.widthMultiplier,
                              child:
                                  AttachmentImage(individuals[0].profilePhoto)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 95,
                      right: 30,
                      child: Container(
                        height: 78,
                        width: 78,
                        child: ClipOval(
                          child: SizedBox(
                              height: 16 * SizeConfig.heightMultiplier,
                              width: 16 * SizeConfig.widthMultiplier,
                              child:
                                  AttachmentImage(individuals[2].profilePhoto)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      bottom: 0,
                      child: Container(
                        height: 170,
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/leaderboard.png",
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ]),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                    itemBuilder: (context, index) => Material(
                        child: InkWell(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            color: AppTheme.project3.withOpacity(0.3),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    color: Colors.red,
                                    width: 70,
                                    height: 70,
                                    child: Center(
                                      child: Text(
                                        '#' + (index + 1).toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )),
                                SizedBox(width: 10),

                                Text(individuals[index].name,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                // Icon(Icons.arrow_forward_ios,
                                //     color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                    // ListTile(
                    //   onTap: () => Navigator.of(context).pushNamed(
                    //       ProfileScreen.routeName,
                    //       arguments: individuals[index].accountId),
                    //   leading: ClipOval(
                    //       child: Container(
                    //     height: 50,
                    //     width: 50,
                    //     child: AttachmentImage(individuals[index].profilePhoto),
                    //   )),
                    //   title: Text(individuals[index].name),
                    // ),
                    itemCount: individuals.length,
                  ),
                ],
              ),
            )
            */
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
