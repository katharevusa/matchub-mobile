import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageOutgoingRequest with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  List<ResourceRequest> listOfRequests = [];

  getAllOutgoing(Profile profile, accessToken) async {
    listOfRequests = [];
    final url =
        'authenticated/getAllOutgoingDonationRequests?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url, accessToken);
    (responseData as List)
        .forEach((e) => listOfRequests.add(ResourceRequest.fromJson(e)));
    notifyListeners();
    return listOfRequests;
  }

  getAllProjectOutgoing(Profile profile, accessToken) async {
    listOfRequests = [];
    final url =
        'authenticated/getAllOutgoingResourceRequests?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url, accessToken);
    (responseData as List)
        .forEach((e) => listOfRequests.add(ResourceRequest.fromJson(e)));
    notifyListeners();
    return listOfRequests;
  }
}
