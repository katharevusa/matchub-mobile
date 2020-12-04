import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageNotification with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  List<Announcement> allAnnouncementForUsers = [];
  List<Announcement> projectInternalAnnouncement = [];
  List<Announcement> projectPublicAnnouncement = [];

  getAllAnnouncementForUsers(Profile profile) async {
    allAnnouncementForUsers = [];
    final url =
        'authenticated/getAnnouncementsByUserId?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => allAnnouncementForUsers.add(Announcement.fromJson(e)));
    notifyListeners();
    return allAnnouncementForUsers;
  }

  getAllProjectInternal(Project project, Profile profile) async {
    projectInternalAnnouncement = [];
    final url =
        'authenticated/viewProjectInternalAnnouncements?projectId=${project.projectId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List).forEach(
        (e) => projectInternalAnnouncement.add(Announcement.fromJson(e)));
    notifyListeners();
    return projectInternalAnnouncement;
  }

  getAllProjectPublic(Project project, Profile profile) async {
    projectPublicAnnouncement = [];
    final url =
        'authenticated/viewProjectPublicAnnouncements?projectId=${project.projectId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List).forEach(
        (e) => projectPublicAnnouncement.add(Announcement.fromJson(e)));
    notifyListeners();
    return projectPublicAnnouncement;
  }
}
