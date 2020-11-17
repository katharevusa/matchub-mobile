import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/project.dart';
import 'package:matchub_mobile/unused/profile_card.dart';
import 'package:matchub_mobile/screens/home/components/featuredProjects.dart';
import 'package:matchub_mobile/screens/home/leaderboard&achievement/ranking.dart';
import 'package:matchub_mobile/unused/profile_card.dart';
import 'package:matchub_mobile/screens/profile/profile_projects.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/project_vertical_card.dart';
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
  var currentPage = images.length - 1.0;
  PageController controller = PageController(initialPage: images.length - 1);
  Future recommendedProfileFuture;
  List<Profile> recoProfiles = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Profile myProfile;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    recommendedProfileFuture = getRecoProfiles();

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
          Ranking(),
          FeaturedProjects(),

          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: SizeConfig.widthMultiplier * 4.0, vertical: 4),
          //   child: Text(
          //     "Featured Projects",
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 2.2 * SizeConfig.textMultiplier,
          //     ),
          //   ),
          // ),
          // Stack(
          //   children: <Widget>[
          //     CardScrollWidget(currentPage),
          //     Positioned.fill(
          //       child: PageView.builder(
          //         // physics: BouncingScrollPhysics(),
          //         itemCount: images.length,
          //         controller: controller,
          //         reverse: true,
          //         itemBuilder: (context, index) {
          //           return Container();
          //         },
          //       ),
          //     )
          //   ],
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: SizeConfig.widthMultiplier * 4.0, vertical: 4),
          //   child: Text(
          //     "Because You Liked",
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 2.2 * SizeConfig.textMultiplier,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: SizeConfig.widthMultiplier * 4.0, vertical: 4),
          //   child: Text(
          //     "Recommended Profiles For You",
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 2.2 * SizeConfig.textMultiplier,
          //     ),
          //   ),
          // ),
          // buildProfileScoller(),
        ],
      ),
    );
  }

  // Widget buildProfileScoller() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 16.0),
  //     child: SizedBox.fromSize(
  //       size: Size.fromHeight(245.0),
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //         itemCount: recoProfiles.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return ProfileCard(recoProfiles[index]);
  //         },
  //       ),
  //     ),
  //   );
  // }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.currentPage);

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

        for (var i = 0; i < images.length; i++) {
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
                      Image.asset(images[i], fit: BoxFit.cover),
                      Align(
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
                                child: Text(title[i],
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
                      )
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

List<String> images = [
  "assets/images/kathmandu1.jpg",
  "assets/images/fries.jpg",
  "assets/images/pablo-sign-in.png",
  "assets/images/kathmandu1.jpg",
  "assets/images/fries.jpg",
  "assets/images/pablo-sign-in.png",
];

List<String> title = [
  "Hounted Ground",
  "Fallen In Love",
  "The Dreaming Moon",
  "Hounted Ground",
  "Fallen In Love",
  "The Dreaming Moon",
];
