import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/unused/rounded_bordered_container.dart';

import '../../../sizeConfig.dart';

class FeaturedProjects extends StatefulWidget {
  @override
  _FeaturedProjectsState createState() => _FeaturedProjectsState();
}

class _FeaturedProjectsState extends State<FeaturedProjects> {
  List<Project> spotLightProjects = [];
  List<Resources> spotLightResources = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Future loadFuture;
  @override
  void initState() {
    loadFuture = load();
    super.initState();
  }

  load() async {
    await getSpotLightProjects();
    await getSpotLightResources();
  }

  getSpotLightProjects() async {
    final responseData = await _apiHelper.getProtected(
      "authenticated/page/getSpotlightedProjects",
    );

    spotLightProjects = (responseData['content'] as List)
        .map((e) => Project.fromJson(e))
        .toList();
  }

  getSpotLightResources() async {
    final responseData = await _apiHelper.getProtected(
      "authenticated/page/getSpotlightedResources",
    );

    spotLightResources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();
    print(spotLightResources.length);
  }

  var titleTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Column(
              children: [
                Container(
                  height: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Projects Under Spotlight",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Swiper(
                          pagination:
                              SwiperPagination(margin: const EdgeInsets.only()),
                          viewportFraction: 0.9,
                          itemCount: spotLightProjects.length,
                          loop: false,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(ProjectDetailScreen.routeName,
                                    arguments: spotLightProjects[index]);
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "${ApiBaseHelper.instance.baseUrl}${spotLightProjects[index].projectProfilePic.substring(30)}"),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            spotLightProjects[index]
                                                .projectTitle,
                                            style: titleTextStyle,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "End Date: ${DateFormat('dd-MMM-yyyy ').format(spotLightProjects[index].endDate)}",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                spotLightProjects[index]
                                                        .upvotes
                                                        .toString() +
                                                    " Upvotes",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 140,
                                      left: 20.0,
                                      child: Container(
                                        color: Colors.green,
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "SPOTLIGHT",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          // itemWidth: 300.0,
                          // itemHeight: 400.0,
                          // layout: SwiperLayout.TINDER,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Resources Under Spotlight",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                        ),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: Swiper(
                          // itemWidth: 200.0,
                          // itemHeight: 400.0,
                          // layout: SwiperLayout.STACK,
                          pagination:
                              SwiperPagination(margin: const EdgeInsets.only()),
                          viewportFraction: 0.9,
                          itemCount: spotLightResources.length,
                          loop: false,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(ResourceDetailScreen.routeName,
                                        arguments: spotLightResources[index]);
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "${ApiBaseHelper.instance.baseUrl}${spotLightResources[index].resourceProfilePic.substring(30)}"),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            spotLightResources[index]
                                                .resourceName,
                                            style: titleTextStyle,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Quantity: ' +
                                                    spotLightResources[index]
                                                        .units
                                                        .toString() +
                                                    " Units",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                spotLightResources[index]
                                                    .resourceType
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 140,
                                      left: 20.0,
                                      child: Container(
                                        color: Colors.green,
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "SPOTLIGHT",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
