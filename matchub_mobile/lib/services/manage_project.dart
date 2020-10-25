import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:path/path.dart';

class ManageProject with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Project managedProject;
  List<Project> allOwnedProjects = [];
  List<Project> followingProjects = [];
  getAllOwnedProjects(Profile profile, accessToken) async {
    allOwnedProjects = [];
    final url = 'authenticated/getOwnedProjects?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url, accessToken);
    (responseData as List)
        .forEach((e) => allOwnedProjects.add(Project.fromJson(e)));

    notifyListeners();
    return allOwnedProjects;
  }

  getAllFollowingProjects(Profile profile) async {
    followingProjects = [];
    final url =
        'authenticated/getListOfFollowingProjectsByUserId?userId=${profile.accountId}';
    final responseData =
        await _apiHelper.getWODecode(url, ApiBaseHelper.accessToken);
    (responseData as List)
        .forEach((e) => followingProjects.add(Project.fromJson(e)));
    notifyListeners();
    return followingProjects;
  }

  getProject(int projectId) async {
    final response = await _apiHelper.getProtected(
      "authenticated/getProject?projectId=$projectId",
    );
    managedProject = Project.fromJson(response);
    print(managedProject.projectBadge);
    notifyListeners();
    return managedProject;
  }
}
