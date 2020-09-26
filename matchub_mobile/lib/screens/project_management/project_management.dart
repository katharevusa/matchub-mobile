import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/drawerMenu.dart';
import 'package:matchub_mobile/screens/project/project_management_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import 'channels/channel_messages.dart';
import 'pManagement_drawer.dart';

class ProjectManagementOverview extends StatefulWidget {
  static const routeName = "/project-management";
  Project project;

  ProjectManagementOverview(this.project);

  @override
  _ProjectManagementOverviewState createState() =>
      _ProjectManagementOverviewState();
}

class _ProjectManagementOverviewState extends State<ProjectManagementOverview> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool isLoaded;
  @override
  void initState() {
    setState(() {
      isLoaded = false;
    });
    loadProject();
    super.initState();
  }

  loadProject() async {
    final response = await ApiBaseHelper().getProtected(
        "authenticated/getProject?projectId=${widget.project.projectId}",
        Provider.of<Auth>(context, listen: false).accessToken);
    widget.project = Project.fromJson(response);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: ProjectManagementDrawer(project: widget.project),
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        elevation: 0,
        leadingWidth: 199,
        leading: IconButton(
          icon: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: Colors.black,
              ),
              Text("Projects", style: TextStyle(color: Colors.black))
            ],
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              _key.currentState.openDrawer();
            },
          ),
        ],
      ),
      body: isLoaded
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.project.projectTitle,
                    style: TextStyle(fontSize: 2.7 * SizeConfig.textMultiplier),
                  ),
                )
              ],
            )
          : Container(),
    );
  }
}
