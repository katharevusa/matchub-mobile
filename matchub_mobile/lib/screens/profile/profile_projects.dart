import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/screens/project_management/project_management.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/project_vertical_card.dart';

class ProfileProjects extends StatelessWidget {
  List<Project> projects;
  bool isOwner;
  ProfileProjects({@required this.projects, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (projects.isEmpty)
          ? Center(
              child: Text("No Projects Available", style: AppTheme.titleLight))
          : ListView.builder(
            shrinkWrap:true,
              itemBuilder: (context, index) => ProjectVerticalCard(
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
