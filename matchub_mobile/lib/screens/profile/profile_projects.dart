import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/search/project_search_card.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/projectGridCard.dart';
import 'package:matchub_mobile/widgets/project_vertical_card.dart';

class ProfileProjects extends StatelessWidget {
  List<Project> projects;
  bool isOwner;
  bool scrollable;
  ProfileProjects({@required this.projects, this.isOwner = false, this.scrollable = true});

  @override
  Widget build(BuildContext context) {
    return (projects.isEmpty)
          ? Center(
              child: Text("No Projects Available", style: AppTheme.titleLight))
          : ListView.builder(
              physics: scrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ProjectGridCard(
                project: projects[index],
              ),
              itemCount: projects.length,
            );
  }
}