import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageProject with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Project managedProject;

  getProject(int projectId, accessToken) async {
    final response = await _apiHelper.getProtected(
        "authenticated/getProject?projectId=$projectId", accessToken: accessToken);
    managedProject = Project.fromJson(response);
    notifyListeners();
    return managedProject;
  }
}
