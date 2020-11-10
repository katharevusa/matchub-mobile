import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class ProjectSearchCard extends StatelessWidget {
  ProjectSearchCard({
    Key key,
    @required this.project,
  }) : super(key: key);
  Project project;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(ProjectDetailScreen.routeName, arguments: project);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 10, horizontal: 4 * SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ]),
                    width: 24 * SizeConfig.widthMultiplier,
                    height: 24 * SizeConfig.widthMultiplier,
                    child: AttachmentImage(project.projectProfilePic))),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 2 * SizeConfig.widthMultiplier,
                    vertical: 1 * SizeConfig.heightMultiplier),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.projectTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 1.6 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900])),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: project.country + " ⚬ ",
                            style: AppTheme.selectedTabLight),
                        TextSpan(
                            text: project.upvotes.toString(),
                            style: AppTheme.selectedTabLight),
                        TextSpan(
                            text: " upvotes ⚬ ", style: AppTheme.searchLight),
                        TextSpan(
                            text: project.teamMembers.length.toString(),
                            style: AppTheme.selectedTabLight),
                        TextSpan(
                            text: " contributors", style: AppTheme.searchLight),
                      ])),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 100 * SizeConfig.widthMultiplier,
                      alignment: Alignment.centerLeft,
                      height: 4 * SizeConfig.heightMultiplier,
                      child: Tags(
                        direction: Axis.vertical,
                        horizontalScroll: true,
                        itemCount: project.sdgs.length > 1 ? 2 : 1, // required
                        itemBuilder: (int index) {
                          return ItemTags(
                            key: Key(index.toString()),
                            index: index, // required
                            title: project.sdgs[index].sdgName,
                            color: Colors.blueGrey[300],
                            border: Border.all(color: Colors.grey[400]),
                            textColor: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            elevation: 0,
                            active: false,
                            pressEnabled: false,
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12.0),
                          );
                        },
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        spacing: 6,
                        runSpacing: 6,
                      ),
                    ),
                    // Container(margin: EdgeInsets.only(top:2),
                    //   height: 48,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     shrinkWrap: true,
                    //       itemBuilder: (BuildContext context, int index) {
                    //     int i = (project.sdgs[index].sdgId);
                    //     return Container(
                    //       child: Image.asset("assets/icons/goal$i.png"),
                    //     );
                    //   },
                    //   itemCount: project.sdgs.length,),
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
            ),
            height: 100,
            width: 100,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
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
