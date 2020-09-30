import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/screens/project_management/project_management.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:random_color/random_color.dart';

class ProfileProjects extends StatelessWidget {
  List<Project> projects;
  bool isOwner;
  ProfileProjects({@required this.projects, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor = RandomColor();
    return Scaffold(
      body: (projects.isEmpty)
          ? Center(
              child: Text("No Projects Available", style: AppTheme.titleLight))
          : ListView.builder(
              itemBuilder: (context, index) => ProjectVerticalCard(
                  randomColor: _randomColor,
                  project: projects[index],
                  isOwner: isOwner),
              itemCount: projects.length,
            ),
    );
  }

  final coverPhoto = [
    "assets/images/projectdefault1.png",
    "assets/images/projectdefault2.png",
    "assets/images/projectdefault3.png"
  ];
}

class ProjectVerticalCard extends StatelessWidget {
  const ProjectVerticalCard(
      {Key key,
      @required RandomColor randomColor,
      @required this.project,
      @required this.isOwner})
      : _randomColor = randomColor,
        super(key: key);
  final bool isOwner;
  final RandomColor _randomColor;
  final Project project;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isOwner
            ? Navigator.of(
                context,
              ).pushNamed(ProjectManagementOverview.routeName,
                arguments: project)
            : Navigator.of(
                context,
              ).pushNamed(ProjectDetailScreen.routeName,
                arguments: project.projectId);
      },
      child: Container(
        constraints:
            BoxConstraints(minHeight: 20 * SizeConfig.heightMultiplier),
        margin: EdgeInsets.symmetric(
            vertical: 1 * SizeConfig.heightMultiplier,
            horizontal: 2 * SizeConfig.heightMultiplier),
        padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _randomColor
              .randomColor(
                  colorBrightness: ColorBrightness.veryLight,
                  colorHue: ColorHue.multiple(
                      colorHues: [ColorHue.green, ColorHue.blue]),
                  colorSaturation: ColorSaturation.lowSaturation)
              .withAlpha(50),
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 3),
              blurRadius: 10,
              color: kSecondaryColor.withOpacity(0.1),
            ),
            BoxShadow(
              offset: Offset(-4, -3),
              blurRadius: 10,
              color: kSecondaryColor.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                    padding: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
                    color: Colors.white,
                    width: 25 * SizeConfig.widthMultiplier,
                    height: 18 * SizeConfig.heightMultiplier,
                    child: AttachmentImage(project.projectProfilePic))),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: 1 * SizeConfig.heightMultiplier),
                      child: Text(project.projectTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                          ))),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.7 * SizeConfig.heightMultiplier,
                        left: 1 * SizeConfig.heightMultiplier),
                    child: Text(project.projectDescription,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            height: 1.6,
                            fontSize: 1.3 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[850])),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: 1 * SizeConfig.heightMultiplier,
                                left: 1 * SizeConfig.heightMultiplier),
                            child: Tags(
                              key: UniqueKey(),
                              itemCount: 1, // required
                              itemBuilder: (int idx) {
                                return ItemTags(
                                  index: idx, // required
                                  title: project.projStatus,
                                  textStyle: TextStyle(
                                    fontSize: 1.6 * SizeConfig.textMultiplier,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                  activeColor: Colors.orange[200],
                                  combine: ItemTagsCombine.withTextBefore,
                                  active: true,
                                  pressEnabled: false,
                                  elevation: 2,
                                );
                              },
                            )),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
