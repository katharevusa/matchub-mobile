import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageOutgoingRequest with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  List<ResourceRequest> requestsToOtherResource = [];
  List<ResourceRequest> requestToOtherProject = [];
  List<ResourceRequest> requestToMyResource = [];
  List<ResourceRequest> requestToMyProject = [];
  getRequestsToOtherResource(Profile profile, accessToken) async {
    requestsToOtherResource = [];
    final url =
        'authenticated/getAllOutgoingDonationRequests?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List).forEach(
        (e) => requestsToOtherResource.add(ResourceRequest.fromJson(e)));
    notifyListeners();
    return requestsToOtherResource;
  }

  getRequestsToOtherProject(Profile profile, accessToken) async {
    requestToOtherProject = [];
    final url =
        'authenticated/getAllOutgoingResourceRequests?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => requestToOtherProject.add(ResourceRequest.fromJson(e)));
    notifyListeners();
    return requestToOtherProject;
  }

  getRequestsToMyProject(Profile profile, accessToken) async {
    requestToMyProject = [];
    final url =
        'authenticated/getAllIncomingResourceDonationRequests?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => requestToMyProject.add(ResourceRequest.fromJson(e)));
    notifyListeners();
    return requestToMyProject;
  }

  getRequestsToMyResource(Profile profile, accessToken) async {
    requestToMyResource = [];
    final url =
        'authenticated/getAllIncomingResourceRequests?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => requestToMyResource.add(ResourceRequest.fromJson(e)));
    notifyListeners();
    return requestToMyResource;
  }
}
