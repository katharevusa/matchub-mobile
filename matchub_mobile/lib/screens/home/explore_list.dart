import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/project.dart';
import 'package:matchub_mobile/screens/home/components/featuredProjects.dart';
import 'package:matchub_mobile/screens/home/components/profileCard.dart';
import 'package:matchub_mobile/screens/profile/profile_projects.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/project_vertical_card.dart';
import 'package:matchub_mobile/widgets/rounded_bordered_container.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../sizeconfig.dart';

class ExploreList extends StatefulWidget {
  @override
  _ExploreListState createState() => _ExploreListState();
}

var cardAspectRatio = 12.0 / 8.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _ExploreListState extends State<ExploreList> {
  var currentPage;
  PageController controller;

  Future recommendedProfileFuture;
  List<Profile> recoProfiles = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Profile myProfile;
  Future spotLightProjectsFuture;
  List<Project> spotLightProjects = [];

  @override
  void initState() {
    getRecoProfiles();

    // currentPage = spotLightProjects.length - 1.0;
    // controller = PageController(initialPage: spotLightProjects.length - 1);
    // controller.addListener(() {
    //   setState(() {
    //     currentPage = controller.page;
    //   });
    // });
    super.initState();
  }

  getRecoProfiles() async {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;

    final responseData = await _apiHelper.getProtected(
      "authenticated/recommendProfiles/${myProfile.accountId}",
    );

    recoProfiles = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context, listen: false).myProfile;

    List<Project> allProjects = [];
    allProjects
      ..addAll(myProfile.projectsOwned)
      ..addAll(myProfile.projectsJoined);

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeaturedProjects(),

          // Stack(
          //   children: <Widget>[
          //     CardScrollWidget(currentPage, spotLightProjects),
          //     Positioned.fill(
          //       child: PageView.builder(
          //         // physics: BouncingScrollPhysics(),
          //         itemCount: spotLightProjects.length,
          //         controller: controller,
          //         reverse: true,
          //         itemBuilder: (context, index) {
          //           return Container();
          //         },
          //       ),
          //     )
          //   ],
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4.0, vertical: 4),
            child: Text(
              "Because You Liked",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 2.2 * SizeConfig.textMultiplier,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4.0, vertical: 4),
            child: Text(
              "Recommended Profiles For You",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 2.2 * SizeConfig.textMultiplier,
              ),
            ),
          ),
          buildProfileScoller(),
        ],
      ),
    );
  }

  Widget buildProfileScoller() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox.fromSize(
        size: Size.fromHeight(245.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemCount: recoProfiles.length,
          itemBuilder: (BuildContext context, int index) {
            return ProfileCard(recoProfiles[index]);
          },
        ),
      ),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  List<Project> spotLightProjects;
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.currentPage, this.spotLightProjects);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < spotLightProjects.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(4.0, 6.0),
                        blurRadius: 5.0),
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      AttachmentImage(
                        spotLightProjects[i].projectProfilePic,
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        width: contraints.maxWidth,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black, Colors.black12])),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        width: contraints.maxWidth,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  spotLightProjects[i].projectTitle,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1),
                                ),
                              ],
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  "${spotLightProjects[i].upvotes}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ))
                          ],
                        ),
                      ),
                      /*    Align(
                        alignment: Alignment.bottomLeft,
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[850].withOpacity(0.8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(spotLightProjects[i].projectTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )*/
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
