import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/widgets/projectVerticalCard.dart';
import 'package:provider/provider.dart';

import '../../style.dart';

class ViewFollowingProjects extends StatefulWidget {
  Profile profile;
  ViewFollowingProjects({this.profile});

  @override
  _ViewFollowingProjectsState createState() => _ViewFollowingProjectsState();
}

class _ViewFollowingProjectsState extends State<ViewFollowingProjects> {
  List<Project> followingProjects = [];
  Future followingProjectsFuture;
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  @override
  @override
  void initState() {
    super.initState();
    loadFollowing();
  }

  loadFollowing() async {
    await Provider.of<ManageProject>(context, listen: false)
        .getAllFollowingProjects(widget.profile);
  }

  // getAllFollowingProjects() async {
  //   final url =
  //       'authenticated/getListOfFollowingProjectsByUserId?userId=${widget.profile.accountId}';
  //   final responseData = await _apiHelper.getWODecode(
  //       url, Provider.of<Auth>(context, listen: false).accessToken);
  //   (responseData as List)
  //       .forEach((e) => followingProjects.add(Project.fromJson(e)));
  // }

  @override
  Widget build(BuildContext context) {
    followingProjects = Provider.of<ManageProject>(context).followingProjects;
    return 
    // FutureBuilder(
    //   future: followingProjectsFuture,
    //   builder: (context, snapshot) => (snapshot.connectionState ==
    //           ConnectionState.done)
    //       ?
           Scaffold(
              appBar: AppBar(
                title: Text("Following Projects"),
              ),
              body: (followingProjects.isEmpty)
                  ? Center(
                      child: Text("No Projects Available",
                          style: AppTheme.titleLight))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ProjectVerticalCard(
                          project: followingProjects[index],
                          isOwner: checkForOwnership(followingProjects[index])),
                      itemCount: followingProjects.length,
                    ),
          //   )
          // : Center(child: CircularProgressIndicator()),
    );
  }

  bool checkForOwnership(Project followingProject) {
    if (widget.profile.projectsOwned.contains(followingProject)) {
      return true;
    }
    return false;
  }
}
