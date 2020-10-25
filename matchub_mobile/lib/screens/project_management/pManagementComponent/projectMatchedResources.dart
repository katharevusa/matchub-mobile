import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

import '../../../sizeconfig.dart';

class PManagementMatchedResources extends StatefulWidget {
  Project project;
  PManagementMatchedResources(this.project);

  @override
  _PManagementMatchedResourcesState createState() =>
      _PManagementMatchedResourcesState();
}

class _PManagementMatchedResourcesState
    extends State<PManagementMatchedResources> {
  List<Resources> matchedResources = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  List<Resources> recommendedResources = [];
  Future loadResources;

  @override
  void initState() {
    loadResources = getMatchedResources();
    super.initState();
  }

  getMatchedResources() async {
    matchedResources = [];
    final url =
        'authenticated/getMatchedResourcesByProjectId?projectId=${widget.project.projectId}';
    final responseData = await _apiHelper.getWODecode(
        url);
    (responseData as List)
        .forEach((e) => matchedResources.add(Resources.fromJson(e)));
    await getRecommendedResources();
  }

  getRecommendedResources() async {
    final responseData = await _apiHelper.getProtected(
      "authenticated/recommendResources/pageable/${widget.project.projectId}",
    );
    recommendedResources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadResources,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Column(
              children: [
                ListTile(
                  title: Text("Matched Resources",
                      style: TextStyle(color: Colors.black)),
                ),
                matchedResources.isEmpty
                    ? Container(
                        child: Center(
                            child: Text(
                                "No matched resources yet. Discover more at our Explore.",
                                style: TextStyle(color: Colors.grey))))
                    : Container(
                        height: 28 * SizeConfig.widthMultiplier,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: matchedResources.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Material(
                                child: InkWell(
                              onTap: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(ResourceDetailScreen.routeName,
                                          arguments: matchedResources[index]),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 20.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 70,
                                    color: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          color: Colors.red,
                                          width: 70,
                                          height: 70,
                                          child: matchedResources[index]
                                                  .photos
                                                  .isNotEmpty
                                              ? AttachmentImage(
                                                  matchedResources[index]
                                                      .photos[0],
                                                )
                                              : Image.asset(
                                                  "assets/images/resource-default2.png"),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                matchedResources[index]
                                                    .resourceName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  matchedResources[index]
                                                      .resourceDescription,
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward_ios,
                                            color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ));
                          },
                        ),
                      ),
                ListTile(
                  title: Text("Suggested Resources For you",
                      style: TextStyle(color: Colors.black)),
                ),
                recommendedResources.isEmpty
                    ? Container(child: Center(child: Text("No suggestions.")))
                    : Container(
                        height: recommendedResources.length.toDouble() * 80,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: recommendedResources.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Material(
                                child: InkWell(
                              onTap: () => Navigator.of(context,
                                      rootNavigator: true)
                                  .pushNamed(ResourceDetailScreen.routeName,
                                      arguments: recommendedResources[index]),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20.0),
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
                                          child: recommendedResources[index]
                                                  .photos
                                                  .isNotEmpty
                                              ? AttachmentImage(
                                                  recommendedResources[index]
                                                      .photos[0],
                                                )
                                              : Image.asset(
                                                  "assets/images/resource-default2.png"),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                recommendedResources[index]
                                                    .resourceName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  recommendedResources[index]
                                                      .resourceDescription,
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                        // Icon(Icons.arrow_forward_ios,
                                        //     color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                                // child: Card(
                                //   color: Colors.white,
                                //   child: ListTile(
                                //     leading: matchedResources[index].photos.isNotEmpty
                                //         ? AttachmentImage(
                                //             matchedResources[index].photos[0],
                                //           )
                                //         : Image.asset(
                                //             "assets/images/resource-default2.png"),
                                //     title: Text(
                                //       matchedResources[index].resourceName,
                                //       style: TextStyle(fontWeight: FontWeight.bold),
                                //     ),
                                //     subtitle: Text(
                                //         matchedResources[index].resourceDescription),
                                //   ),
                                // ),
                              ),
                            ));
                          },
                        ),
                      ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
