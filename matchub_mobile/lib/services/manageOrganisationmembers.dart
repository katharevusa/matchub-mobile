import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageOrganisationMembers with ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  List<Profile> members;  
  List<Profile> listOfKah;

  getKahs(Profile profile) async {
    final url = 'authenticated/organisation/viewKAHs/${profile.accountId}';
    final responseData = await _helper.getProtected(url);
    listOfKah = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
    notifyListeners();
    return listOfKah;
  }

  getMembers(Profile profile) async {
    final url = 'authenticated/organisation/viewMembers/${profile.accountId}';
    final responseData = await _helper.getProtected(url);
    members = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
    notifyListeners();
    return members;
  }
}
