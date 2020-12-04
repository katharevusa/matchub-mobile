import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/resourceDonate.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../style.dart';

class PActions extends StatefulWidget {
  Project project;
  PActions(this.project);

  @override
  _PActionsState createState() => _PActionsState();
}

class _PActionsState extends State<PActions> {
  Profile myProfile;
  List<Project> followingProjects = [];
  Future followingProjectsFuture;
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  @override
  void didChangeDependencies() {
    followingProjectsFuture = getAllFollowingProjects();
    print("hello");
    super.didChangeDependencies();
  }

  getAllFollowingProjects() async {
    myProfile = Provider.of<Auth>(this.context).myProfile;
    followingProjects = [];
    final url =
        'authenticated/getListOfFollowingProjectsByUserId?userId=${myProfile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => followingProjects.add(Project.fromJson(e)));
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(this.context).myProfile;
    return FutureBuilder(
      future: followingProjectsFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(32.0),
                  width: 100*SizeConfig.widthMultiplier,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      color: Colors.black.withOpacity(0.8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () async {
                          if (followingProjects.indexWhere((element) =>
                                  element.projectId ==
                                  widget.project.projectId) !=
                              -1) {
                            await ApiBaseHelper.instance.deleteProtected(
                                "authenticated/UnfollowProject?followerId=${myProfile.accountId}&projectId=${widget.project.projectId}");
                          } else if (followingProjects.indexWhere((element) =>
                                  element.projectId ==
                                  widget.project.projectId) ==
                              -1) {
                            await ApiBaseHelper.instance.putProtected(
                                "authenticated/followProject?followerId=${myProfile.accountId}&projectId=${widget.project.projectId}");
                          }
                          await Provider.of<Auth>(context, listen: false)
                              .retrieveUser();
                          await loadFollowing();
                          setState(() {
                            getProjects();
                          });
                        },
                        color: AppTheme.project4,
                        textColor: Colors.white,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            (followingProjects.indexWhere((element) =>
                                        element.projectId ==
                                        widget.project.projectId) ==
                                    -1
                                ? Text(
                                    "Follow",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  )
                                : Text(
                                    "Unfollow",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ))
                          ],
                        ),
                      ),
                      if (widget.project.teamMembers.indexWhere((element) =>
                                  element.accountId == myProfile.accountId) ==
                              -1
                          // && project.joinRequests.indexWhere((element) => element.requestor.accountId==myProfile.accountId) == -1
                          &&
                          widget.project.projectOwners.indexWhere((element) =>
                                  element.accountId == myProfile.accountId) ==
                              -1)
                        RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () async {
                            await joinProject();
                            Provider.of<Auth>(context, listen: false)
                                .retrieveUser();
                          },
                          color: AppTheme.project4,
                          textColor: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Join",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                      if (widget.project.teamMembers.indexWhere((element) =>
                              element.accountId == myProfile.accountId) >
                          -1)
                        //only able to leave a projct that youre a team member of
                        RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () async {
                            await leaveProject();
                            Provider.of<Auth>(context, listen: false)
                                .retrieveUser();
                          },
                          color: AppTheme.project4,
                          textColor: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Leave",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                      RaisedButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DonateFormScreen(widget.project)));
                        },
                        color: AppTheme.project4,
                        textColor: Colors.white,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Contribute",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  loadFollowing() async {
    await Provider.of<ManageProject>(this.context, listen: false)
        .getAllFollowingProjects(myProfile);
  }

  joinProject() async {
    final url =
        "authenticated/createJoinRequest?projectId=${widget.project.projectId}&profileId=${myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.postProtected(
        url,
      );
      print("Success");
      Navigator.of(this.context).pop("Joined-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }

  leaveProject() async {
    final url =
        "authenticated/leaveProject?projectId=${widget.project.projectId}&memberId=${myProfile.accountId}";
    try {
      var accessToken = Provider.of<Auth>(this.context).accessToken;
      final response =
          await ApiBaseHelper().deleteProtected(url, accessToken: accessToken);

      await DatabaseMethods()
          .removeFromChannels(myProfile.uuid, widget.project.projectId);
      print("Success");
      Navigator.of(this.context).pop("Delete-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }

  getProjects() async {
    await Provider.of<ManageProject>(this.context, listen: false).getProject(
      widget.project.projectId,
    );
  }
}
