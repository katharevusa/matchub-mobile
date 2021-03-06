import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class ManageCompetition with ChangeNotifier {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;

  List<Competition> activeCompetitions = [];
  List<Competition> allCompetitions = [];

  getAllActiveCompetition() async {
    activeCompetitions = [];
    final url = 'authenticated/getAllActiveCompetitions';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => activeCompetitions.add(Competition.fromJson(e)));
    notifyListeners();
    return activeCompetitions;
  }

  getAllCompetition() async {
    allCompetitions = [];
    final url = 'authenticated/getAllPastCompetitions';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => allCompetitions.add(Competition.fromJson(e)));
    notifyListeners();
    return allCompetitions;
  }
}
