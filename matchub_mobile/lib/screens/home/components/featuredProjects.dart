import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
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
                        "Featured Projects",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                        ),
                      ),
                      Expanded(
                        child: Swiper(
                          pagination:
                              SwiperPagination(margin: const EdgeInsets.only()),
                          viewportFraction: 0.9,
                          itemCount: spotLightProjects.length,
                          loop: false,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    AttachmentImage(
                                      spotLightProjects[index]
                                          .projectProfilePic,
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      width: 400,
                                      height: 60,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                              Colors.black,
                                              Colors.black26
                                            ])),
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              spotLightProjects[index]
                                                  .projectTitle,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                        "Featured Resources",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                        ),
                      ),
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    AttachmentImage(
                                      spotLightResources[index]
                                          .resourceProfilePic,
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      width: 400,
                                      height: 60,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                              Colors.black,
                                              Colors.black26
                                            ])),
                                      ),
                                    ),
                                    // Positioned(
                                    //   left: 10,
                                    //   bottom: 10,
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              spotLightResources[index]
                                                  .resourceName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
