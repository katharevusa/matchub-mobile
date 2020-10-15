import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class Search with ChangeNotifier {
  List<Profile> searchProfileResults = [];
  List<Project> searchProjectResults = [];
  List<Resources> searchResourcesResults = [];
  String accessToken;
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  bool hasMoreProjects;
  bool hasMoreProfiles;

  Search({this.accessToken});

  globalSearchForUsers(String searchQuery, {pageNo = 0, Map<String, dynamic> filterOptions}) async {
    if (pageNo == 0) searchProfileResults.clear();
    var filter = "";
    if (filterOptions != null) {
      if (filterOptions['country'] != null) {
        var countryQuery = "&country=${filterOptions['country']}";
        filter += countryQuery;
      }
      for (num i in filterOptions['sdgs']) {
        filter += "&sdgIds=${i+1}";
      }
    }
    var responseData = await _apiHelper.getProtected(
        "authenticated/globalSearchAllUsers?search=$searchQuery&size=8&page=$pageNo$filter",
        accessToken);
    searchProfileResults.addAll((responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList());
    hasMoreProfiles = !responseData['last'];
  }

  globalSearchForProjects(String searchQuery,
      {pageNo = 0, Map<String, dynamic> filterOptions}) async {
    if (pageNo == 0) searchProjectResults.clear();
    var filter = "";
    if (filterOptions != null) {
      if (filterOptions['status'] != null) {
        var statusQuery = "&status=";
        var value = filterOptions['status'];
        if (value == 'Pending') {
          statusQuery += "ON_HOLD";
        } else if (value == 'Active') {
          statusQuery += "ACTIVE";
        } else if (value == 'Completed') {
          statusQuery += "COMPLETED";
        }
        filter += statusQuery;
      }
      if (filterOptions['country'] != null) {
        var countryQuery = "&country=${filterOptions['country']}";
        filter += countryQuery;
      }
      for (num i in filterOptions['sdgs']) {
        filter += "&sdgIds=${i+1}";
      }
    }
    var responseData = await _apiHelper.getProtected(
        "authenticated/projectGlobalSearch?keywords=$searchQuery&size=10&page=$pageNo$filter",
        accessToken);
    searchProjectResults.addAll((responseData['content'] as List)
        .map((e) => Project.fromJson(e))
        .toList());
    hasMoreProjects = !responseData['last'];
  }
}
