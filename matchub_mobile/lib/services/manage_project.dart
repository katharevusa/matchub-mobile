import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageProject with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Project managedProject;
  List<Project> allOwnedProjects = [];

  getAllOwnedProjects(Profile profile, accessToken) async {
    allOwnedProjects = [];
    final url = 'authenticated/getOwnedProjects?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url, accessToken);
    (responseData as List)
        .forEach((e) => allOwnedProjects.add(Project.fromJson(e)));

    notifyListeners();
    return allOwnedProjects;
  }

  getProject(int projectId) async {
    final response = await _apiHelper.getProtected(
      "authenticated/getProject?projectId=$projectId",
    );
    managedProject = Project.fromJson(response);
    notifyListeners();
    return managedProject;
  }
}
