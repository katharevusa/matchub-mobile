import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/project_management/project_management.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProjectVerticalCard extends StatefulWidget {
  const ProjectVerticalCard(
      {Key key, @required this.project, @required this.isOwner});
  final bool isOwner;
  final Project project;

  @override
  _ProjectVerticalCardState createState() => _ProjectVerticalCardState();
}

class _ProjectVerticalCardState extends State<ProjectVerticalCard> {
  bool _isLoading;
  TruncatedProfile projectOwner;
  Project project;

  @override
  initState() {
    _isLoading = true;
    retrieveProjectOwner();
    super.initState();
  }

  retrieveProjectOwner() async {
    var response = await ApiBaseHelper().getProtected(
        "authenticated/getProject?projectId=${widget.project.projectId}",
        Provider.of<Auth>(context, listen: false).accessToken);
    project = Project.fromJson(response);
    response = await ApiBaseHelper().getProtected(
        "authenticated/getAccount/${widget.project.projCreatorId}",
        Provider.of<Auth>(context, listen: false).accessToken);
    projectOwner = TruncatedProfile.fromJson(response);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[300],
              child: ProjectLoader(),
              period: Duration(milliseconds: 800),
            ),
          )
        : GestureDetector(
            onTap: () {
              widget.isOwner
                  ? Navigator.of(
                      context,
                    ).pushNamed(ProjectManagementOverview.routeName,
                      arguments: widget.project)
                  : Navigator.of(
                      context,
                    ).pushNamed(ProjectDetailScreen.routeName,
                      arguments: widget.project);
            },
            child: Stack(children: [
              Container(
                height: 18 * SizeConfig.heightMultiplier,
                constraints:
                    BoxConstraints(minHeight: 20 * SizeConfig.heightMultiplier),
                margin: EdgeInsets.symmetric(
                    vertical: 1 * SizeConfig.heightMultiplier,
                    horizontal: 2 * SizeConfig.heightMultiplier),
                padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(4, 3),
                      blurRadius: 10,
                      color: Colors.grey[850].withOpacity(0.1),
                    ),
                    BoxShadow(
                      offset: Offset(-4, -3),
                      blurRadius: 10,
                      color: Colors.grey[850].withOpacity(0.1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: SizeConfig.widthMultiplier * 23),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 1 * SizeConfig.heightMultiplier),
                              child: Text(widget.project.projectTitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
                                  ))),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.5 * SizeConfig.heightMultiplier,
                                left: 1 * SizeConfig.heightMultiplier),
                            child: Text(widget.project.country,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    height: 1.6,
                                    fontSize: 1.3 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800])),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 0.5 * SizeConfig.heightMultiplier,
                                  left: 1 * SizeConfig.heightMultiplier),
                              child: Text("by ${projectOwner.name}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                      height: 1.6,
                                      fontSize: 1.3 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[700])),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            height: 4 * SizeConfig.heightMultiplier,
                            child: Tags(
                              direction: Axis.horizontal,
                              horizontalScroll: true,
                              itemCount: project.sdgs.length, // required
                              itemBuilder: (int index) {
                                return ItemTags(
                                  key: Key(index.toString()),
                                  index: index, // required
                                  title: project.sdgs[index].sdgName,
                                  color: kScaffoldColor,
                                  border: Border.all(color: Colors.grey[400]),
                                  textColor: Colors.grey[600],
                                  elevation: 0,
                                  active: false,
                                  pressEnabled: false,
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0),
                                );
                              },
                              alignment: WrapAlignment.end,
                              runAlignment: WrapAlignment.start,
                              spacing: 6,
                              runSpacing: 6,
                            ),
                          )
                        ],
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.end,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Padding(
                    //           padding: EdgeInsets.only(
                    //               top: 1 * SizeConfig.heightMultiplier,
                    //               left: 1 * SizeConfig.heightMultiplier),
                    //           child: Tags(
                    //             key: UniqueKey(),
                    //             itemCount: 1, // required
                    //             itemBuilder: (int idx) {
                    //               return ItemTags(
                    //                 index: idx, // required
                    //                 title: widget.project.projStatus,
                    //                 textStyle: TextStyle(
                    //                   fontSize:
                    //                       1.6 * SizeConfig.textMultiplier,
                    //                 ),
                    //                 borderRadius:
                    //                     BorderRadius.circular(2),
                    //                 activeColor: Colors.orange[200],
                    //                 combine:
                    //                     ItemTagsCombine.withTextBefore,
                    //                 active: true,
                    //                 pressEnabled: false,
                    //                 elevation: 2,
                    //               );
                    //             },
                    //           )),
                    //       Icon(Icons.keyboard_arrow_right)
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              Positioned(
                top: 1 * SizeConfig.heightMultiplier,
                child: Hero(
                  tag: widget.project.projectProfilePic,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ]),
                            width: 28 * SizeConfig.widthMultiplier,
                            height: 20 * SizeConfig.heightMultiplier,
                            child: AttachmentImage(
                                widget.project.projectProfilePic))),
                  ),
                ),
              ),
            ]),
          );
  }
}

class ProjectLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 260;
    double containerHeight = 15;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 150,
            width: 100,
            color: Colors.grey,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
