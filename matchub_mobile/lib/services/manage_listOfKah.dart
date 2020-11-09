// import 'package:flutter/material.dart';
// import 'package:matchub_mobile/api/api_helper.dart';
// import 'package:matchub_mobile/models/index.dart';

// class ManageListOfKah with ChangeNotifier {
//   ApiBaseHelper _helper = ApiBaseHelper.instance;
//   List<Profile> listOfKah;

//   getKahs(Profile profile, accessToken) async {
//     final url = 'authenticated/organisation/viewKAHs/${profile.accountId}';
//     final responseData = await _helper.getProtected(url,  accessToken:accessToken);
//     listOfKah = (responseData['content'] as List)
//         .map((e) => Profile.fromJson(e))
//         .toList();
//     notifyListeners();
//     return listOfKah;
//   }
// }
