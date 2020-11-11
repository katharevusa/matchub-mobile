import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class Search with ChangeNotifier {
  List<Profile> searchProfileResults = [];
  List<Project> searchProjectResults = [];
  List<Resources> searchResourcesResults = [];
  List<Campaign> searchCampaignsResults = [];
  String accessToken;
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  bool hasMoreProjects;
  bool hasMoreProfiles;
  bool hasMoreResources;
  bool hasMoreCampaigns;

  Search({this.accessToken});

  globalSearchForUsers(String searchQuery,
      {pageNo = 0, Map<String, dynamic> filterOptions}) async {
    if (pageNo == 0) searchProfileResults.clear();
    var filter = "";
    if (filterOptions != null) {
      if (filterOptions['country'] != null) {
        var countryQuery = "&country=${filterOptions['country']}";
        filter += countryQuery;
      }
      for (num i in filterOptions['sdgs']) {
        filter += "&sdgIds=${i + 1}";
      }
    }
    var responseData = await _apiHelper.getProtected(
        "authenticated/globalSearchAllUsers?search=$searchQuery&size=8&page=$pageNo$filter",
         accessToken:accessToken);
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
        filter += "&country=${filterOptions['country']}";
      }
      for (num i in filterOptions['sdgs']) {
        filter += "&sdgIds=${i + 1}";
      }
    }
    var responseData = await _apiHelper.getProtected(
        "authenticated/projectGlobalSearch?keywords=$searchQuery&size=10&page=$pageNo$filter&sort=upvotes",
        accessToken: accessToken);
    searchProjectResults.addAll((responseData['content'] as List)
        .map((e) => Project.fromJson(e))
        .toList());
    hasMoreProjects = !responseData['last'];
  }

  globalSearchForResources(String searchQuery,
      {pageNo = 0, Map<String, dynamic> filterOptions}) async {
    if (pageNo == 0) searchResourcesResults.clear();
    var filter = "";
    if (filterOptions != null) {
      if (filterOptions['startDate'] != null) {
        filter += "&startTime=${filterOptions['startDate']}T00:00:00";
      }
      if (filterOptions['endDate'] != null) {
        filter += "&endTime=${filterOptions['endDate']}T00:00:00";
      }
      if (filterOptions['categoryIds'].isNotEmpty) {
        for (num i in filterOptions['categoryIds']) {
          filter += "&categoryIds=$i";
        }
      }
      if (filterOptions['country'] != null) {
        filter += "&country=${filterOptions['country']}";
      }
    }
    var responseData = await _apiHelper.getProtected(
        "authenticated/resourceGlobalSearch?keywords=$searchQuery&size=10&page=$pageNo&availability=true$filter",
        accessToken: accessToken);
    searchResourcesResults.addAll((responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList());
    hasMoreResources = !responseData['last'];
  }
  globalSearchForCampaigns(String searchQuery,
      {pageNo = 0, Map<String, dynamic> filterOptions}) async {
    if (pageNo == 0) searchCampaignsResults.clear();
    var responseData = await _apiHelper.getProtected(
        "authenticated/searchCampaignByKeyWord?keyword=$searchQuery&size=10&page=$pageNo",
        accessToken: accessToken);
    searchCampaignsResults.addAll((responseData['content'] as List)
        .map((e) => Campaign.fromJson(e))
        .toList());
    hasMoreCampaigns = !responseData['last'];
  }
}
