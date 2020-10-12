import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class Search with ChangeNotifier {
  List<Profile> searchProfileResults = [];
  List<Project> searchProjectResults = [];
  List<Resources> searchResourcesResults = [];
  String accessToken;
  ApiBaseHelper _apiHelper = ApiBaseHelper();

  Search({this.accessToken});

  globalSearchForUsers(String searchQuery) async {
    var responseData = await _apiHelper.getProtected(
        "authenticated/globalSearchAllUsers?search=$searchQuery", accessToken);
    searchProfileResults = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }
  globalSearchForProjects(String searchQuery) async {
    var responseData = await _apiHelper.getProtected(
        "authenticated/projectGlobalSearch?keywords=$searchQuery&size=5", accessToken);
    searchProjectResults = (responseData['content'] as List)
        .map((e) => Project.fromJson(e))
        .toList();
        print(responseData['totalElements']); 
  }
}
