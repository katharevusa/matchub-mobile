import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageResource with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;

  List<Resources> resources = [];
  List<Resources> savedResources = [];

  getAllSavedResources(Profile profile) async {
    final url =
        'authenticated/getSavedResourcesByAccountId/${profile.accountId}';
    print('reach');
    final responseData = await _apiHelper.getProtected(
      url,
    );
    savedResources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();
    notifyListeners();
    return savedResources;
  }

  getResources(Profile profile, accessToken) async {
    final url =
        'authenticated/getHostedResources?profileId=${profile.accountId}';
    final responseData =
        await _apiHelper.getProtected(url, accessToken: accessToken);
    resources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();
    notifyListeners();
    return resources;
  }
}
