import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class MatchedProjects extends StatefulWidget {
  Resources resource;
  MatchedProjects(this.resource);

  _MatchedProjectsState createState() => _MatchedProjectsState();
}

class _MatchedProjectsState extends State<MatchedProjects> {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  List<Project> recommendedProjects = [];
  List<Project> recommendedProjectsCountry = [];
  Future loadRecommendedProjects;

  @override
  void initState() {
    loadRecommendedProjects = getRecommendedProjects();
    super.initState();
  }

  getRecommendedProjects() async {
    final responseData = await _apiHelper.getProtected(
      "authenticated/recommendProjects/page/${widget.resource.resourceId}",
    );
    recommendedProjects = (responseData['content'] as List)
        .map((e) => Project.fromJson(e))
        .toList();
    final responseData2 = await _apiHelper.getProtected(
      "authenticated/recommendSameCountryProjects/page/${widget.resource.resourceId}",
    );
    recommendedProjectsCountry = (responseData2['content'] as List)
        .map((e) => Project.fromJson(e))
        .toList();
  }

  Widget build(BuildContext context) {
    if (widget.resource.resourceOwnerId ==
        Provider.of<Auth>(context).myProfile.accountId) {
      return FutureBuilder(
        future: loadRecommendedProjects,
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Suggested projects in your country",
                          style: Theme.of(context).textTheme.title,
                        ),
                      ],
                    ),
                  ),
                  recommendedProjectsCountry.isEmpty
                      ? Container(
                          child: Text("No suggestions"),
                        )
                      : Container(
                          color: Colors.transparent,
                          height: 200.0,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedProjectsCountry.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Material(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(ProjectDetailScreen.routeName,
                                        arguments:
                                            recommendedProjectsCountry[index]);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10.0),
                                      width: 150.0,
                                      height: 200.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: Container(
                                                    child: AttachmentImage(
                                                        recommendedProjectsCountry[
                                                                index]
                                                            .projectProfilePic),
                                                  ))),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                              recommendedProjectsCountry[index]
                                                  .projectTitle,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subhead
                                                  .merge(TextStyle(
                                                      color: Colors
                                                          .grey.shade600)))
                                        ],
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                  Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "You may also consider",
                          style: Theme.of(context).textTheme.title,
                        ),
                      ],
                    ),
                  ),
                  recommendedProjects.isEmpty
                      ? Container(child: Text("No suggestions"))
                      : Container(
                          color: Colors.transparent,
                          height: 200.0,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedProjects.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Material(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(ProjectDetailScreen.routeName,
                                        arguments: recommendedProjects[index]);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10.0),
                                      width: 150.0,
                                      height: 200.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: Container(
                                                    child: AttachmentImage(
                                                        recommendedProjects[
                                                                index]
                                                            .projectProfilePic),
                                                  ))),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                              recommendedProjects[index]
                                                  .projectTitle,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subhead
                                                  .merge(TextStyle(
                                                      color: Colors
                                                          .grey.shade600)))
                                        ],
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ))
            : Center(child: CircularProgressIndicator()),
      );
    } else {
      return Container();
    }
  }
}
