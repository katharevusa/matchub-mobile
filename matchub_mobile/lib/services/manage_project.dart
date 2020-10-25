import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageProject with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Project managedProject;

  getProject(int projectId) async {
    final response = await _apiHelper.getProtected(
        "authenticated/getProject?projectId=$projectId",);
    managedProject = Project.fromJson(response);
    notifyListeners();
    return managedProject;
  }
  List<Announcement> allAnnouncementForUsers = [];
  List<Announcement> projectInternalAnnouncement = [];
  List<Announcement> projectPublicAnnouncement = [];
  List<Project> followingProjects = [];

  getAllAnnouncementForUsers(Profile profile, accessToken) async {
    allAnnouncementForUsers = [];
    final url =
        'authenticated/getAnnouncementsByUserId?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => allAnnouncementForUsers.add(Announcement.fromJson(e)));
    notifyListeners();
    return allAnnouncementForUsers;
  }

  getAllProjectInternal(Project project, Profile profile, accessToken) async {
    projectInternalAnnouncement = [];
    final url =
        'authenticated/viewProjectInternalAnnouncements?projectId=${project.projectId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List).forEach(
        (e) => projectInternalAnnouncement.add(Announcement.fromJson(e)));
    notifyListeners();
    return projectInternalAnnouncement;
  }

  getAllProjectPublic(Project project, Profile profile, accessToken) async {
    projectPublicAnnouncement = [];
    final url =
        'authenticated/viewProjectPublicAnnouncements?projectId=${project.projectId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List).forEach(
        (e) => projectPublicAnnouncement.add(Announcement.fromJson(e)));
    notifyListeners();
    return projectPublicAnnouncement;
  }
  

  getAllFollowingProjects(Profile profile) async {
    followingProjects = [];
    final url =
        'authenticated/getListOfFollowingProjectsByUserId?userId=${profile.accountId}';
    final responseData =
        await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => followingProjects.add(Project.fromJson(e)));
    notifyListeners();
    return followingProjects;
  }
}
