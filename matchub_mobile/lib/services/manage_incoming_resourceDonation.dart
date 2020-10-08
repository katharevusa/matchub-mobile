// import 'package:flutter/material.dart';
// import 'package:matchub_mobile/api/api_helper.dart';
// import 'package:matchub_mobile/models/index.dart';

// class ManageIncomingResourceDonation with ChangeNotifier {
//   ApiBaseHelper _apiHelper = ApiBaseHelper();
//   List<ResourceRequest> listOfRequests = [];

//   getAllIncomingResourceDonation(Profile profile, accessToken) async {
//     listOfRequests = [];
//     final url =
//         'authenticated/getAllIncomingResourceDonationRequests?userId=${profile.accountId}';
//     final responseData = await _apiHelper.getWODecode(url, accessToken);
//     (responseData as List)
//         .forEach((e) => listOfRequests.add(ResourceRequest.fromJson(e)));
//     notifyListeners();
//     return listOfRequests;
//   }
// }
