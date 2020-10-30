import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
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
  List<Resources> recommendedResourcesCountry = [];
  List<Resources> recommendedResources = [];
  Future loadResources;
  GlobalKey<TagsState> _tagStateKey =
      GlobalKey<TagsState>(debugLabel: '_tagStateKey');

  @override
  void initState() {
    loadResources = getMatchedResources();
    super.initState();
  }

  getMatchedResources() async {
    matchedResources = [];
    final url =
        'authenticated/getMatchedResourcesByProjectId?projectId=${widget.project.projectId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => matchedResources.add(Resources.fromJson(e)));
    await getRecommendedResources();
  }

  getRecommendedResources() async {
    final responseData = await _apiHelper.getProtected(
      "authenticated/recommendSameCountryResources/page/${widget.project.projectId}",
    );
    recommendedResourcesCountry = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();

    final responseData2 = await _apiHelper.getProtected(
      "authenticated/recommendResources/page/${widget.project.projectId}",
    );
    recommendedResources = (responseData2['content'] as List)
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
                // ListTile(
                //   title: Text("Matched Resources",
                //       style: TextStyle(color: Colors.black)),
                // ),
                // matchedResources.isEmpty
                //     ? Container(
                //         child: Center(
                //             child: Text(
                //                 "No matched resources yet. Discover more at our Explore.",
                //                 style: TextStyle(color: Colors.grey))))
                //     : Container(
                //         height: 28 * SizeConfig.widthMultiplier,
                //         width: double.infinity,
                //         child: ListView.builder(
                //           physics: BouncingScrollPhysics(),
                //           scrollDirection: Axis.vertical,
                //           itemCount: matchedResources.length,
                //           itemBuilder: (BuildContext context, int index) {
                //             return Material(
                //                 child: InkWell(
                //               onTap: () =>
                //                   Navigator.of(context, rootNavigator: true)
                //                       .pushNamed(ResourceDetailScreen.routeName,
                //                           arguments: matchedResources[index]),
                //               child: Padding(
                //                 padding: EdgeInsets.symmetric(
                //                     vertical: 0.0, horizontal: 20.0),
                //                 child: ClipRRect(
                //                   borderRadius: BorderRadius.circular(10),
                //                   child: Container(
                //                     height: 70,
                //                     color: Colors.white,
                //                     child: Row(
                //                       children: <Widget>[
                //                         Container(
                //                           color: Colors.red,
                //                           width: 70,
                //                           height: 70,
                //                           child: matchedResources[index]
                //                                   .photos
                //                                   .isNotEmpty
                //                               ? AttachmentImage(
                //                                   matchedResources[index]
                //                                       .photos[0],
                //                                 )
                //                               : Image.asset(
                //                                   "assets/images/resource-default2.png"),
                //                         ),
                //                         SizedBox(width: 10),
                //                         Expanded(
                //                           child: Column(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.center,
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.start,
                //                             children: <Widget>[
                //                               Text(
                //                                 matchedResources[index]
                //                                     .resourceName,
                //                                 style: TextStyle(
                //                                     fontWeight:
                //                                         FontWeight.bold),
                //                               ),
                //                               Text(
                //                                   matchedResources[index]
                //                                       .resourceDescription,
                //                                   style: TextStyle(
                //                                       color: Colors.grey)),
                //                             ],
                //                           ),
                //                         ),
                //                         Icon(Icons.arrow_forward_ios,
                //                             color: Colors.grey),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ));
                //           },
                //         ),
                //       ),
                ListTile(
                  title: Text("Project Keywords",
                      style: TextStyle(color: Colors.black)),
                ),
                Tags(
                  key: _tagStateKey,
                  itemCount: widget.project.relatedResources.length, // required
                  itemBuilder: (int index) {
                    final item = widget.project.relatedResources[index];

                    return ItemTags(
                      key: Key(index.toString()),
                      index: index, // required
                      title: item,
                      textStyle: TextStyle(
                        fontSize: 14,
                      ),
                      combine: ItemTagsCombine.withTextBefore,
                      active: true,
                      pressEnabled: false,
                    );
                  },
                ),
                ListTile(
                  title: Text("Suggested Resources in your Country",
                      style: TextStyle(color: Colors.black)),
                ),
                recommendedResourcesCountry.isEmpty
                    ? Container(child: Center(child: Text("No suggestions.")))
                    : Container(
                        height:
                            recommendedResourcesCountry.length.toDouble() * 80,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: recommendedResourcesCountry.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Material(
                                child: InkWell(
                              onTap: () => Navigator.of(context,
                                      rootNavigator: true)
                                  .pushNamed(ResourceDetailScreen.routeName,
                                      arguments:
                                          recommendedResourcesCountry[index]),
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
                                          child: recommendedResourcesCountry[
                                                      index]
                                                  .photos
                                                  .isNotEmpty
                                              ? AttachmentImage(
                                                  recommendedResourcesCountry[
                                                          index]
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
                                                recommendedResourcesCountry[
                                                        index]
                                                    .resourceName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  recommendedResourcesCountry[
                                                          index]
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
                              ),
                            ));
                          },
                        ),
                      ),
                ListTile(
                  title: Text("Suggested Resources you may consider",
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
