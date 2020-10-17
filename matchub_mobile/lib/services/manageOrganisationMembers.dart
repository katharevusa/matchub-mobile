import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageOrganisationMembers with ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  List<Profile> members;

  getMembers(Profile profile, accessToken) async {
    final url = 'authenticated/organisation/viewMembers/${profile.accountId}';
    final responseData = await _helper.getProtected(url,  accessToken:accessToken);
    members = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
    notifyListeners();
    return members;
  }
}
