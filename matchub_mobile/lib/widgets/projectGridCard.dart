import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/sizeconfig.dart';

import 'attachment_image.dart';

class ProjectGridCard extends StatelessWidget {
  Project project;
  ProjectGridCard({this.project});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(ProjectDetailScreen.routeName, arguments: project);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 7, left: 7, right: 7),
        child: 
          Stack(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    width: 100 * SizeConfig.widthMultiplier,
                    height: 50 * SizeConfig.widthMultiplier,
                    child: AttachmentImage(project.projectProfilePic))),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: 50 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xCC000000),
                      const Color(0x00000000),
                      const Color(0x00000000),
                      const Color(0x9C000000),
                      const Color(0xCC000000),
                    ],
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Text(
                  project.projectTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                alignment: Alignment.topRight,
                width: 100 * SizeConfig.widthMultiplier,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.thumb_up_sharp, color: Colors.white, size: 16,),SizedBox(width: 5), Text(project.upvotes.toString(), style: TextStyle(color: Colors.white))
                  ]
                )
              ),
            ),
        ]),
      ),
    );
  }
}
