import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/model/post.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _userRole;
  String _accessToken;
  String _refreshToken;
  DateTime _expiryDate;
  String _accountId;
  String _username;
  bool _isIndividual;
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  Profile myProfile;

  bool get isAuth {
    return _accessToken != null;
  }

  bool get isIndividual {
    return _isIndividual;
  }

  String get userRole {
    return _userRole;
  }

  String get userId {
    return _accountId;
  }

  String get username {
    return _username;
  }

  String get accessToken {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _accessToken != null) {
      return _accessToken;
    }
    return null;
  }

  signup(String username, String email, String password,
      List<String> roles) async {
    final url = "public";
    try {
      String body = json.encode({
        "username": username,
        "password": password,
        "email": email,
        "roles": roles
      });
      final responseData = await _apiHelper.post(url, body: body);

      login(username, password);
    } catch (error) {
      throw error;
    }
  }

  saveTokens(Map<dynamic, dynamic> responseData) async {
    _accessToken = responseData['access_token'];
    _refreshToken = responseData['refresh_token'];
    _expiryDate = DateTime.now().add(
      Duration(seconds: responseData['expires_in']),
    );
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'accessToken': _accessToken,
        'refreshToken': _refreshToken,
        'expiryDate': _expiryDate.toIso8601String(),
      },
    );
    prefs.setString('userData', userData);
  }

  Future<bool> login(String username, String password) async {
    final url =
        'oauth/token?password=$password&username=$username&grant_type=password';
    final responseData = await _apiHelper.post(
      url,
    );
    await saveTokens(responseData);
    await retrieveUser();
    notifyListeners();
  }

  Future refreshAcessToken() async {
    try {
      final url =
          'oauth/token?grant_type=refresh_token&refresh_token=$_refreshToken';
      final responseData = await _apiHelper.post(
        url,
      );
      await saveTokens(responseData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    _accessToken = extractedUserData['accessToken'];
    _refreshToken = extractedUserData['refreshToken'];
    _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.subtract(Duration(seconds: 600)).isBefore(DateTime.now())) {
      // accessToken expired
      try {
        refreshAcessToken();
      } catch (error) {
        //refreshToken expired
        logout();
        throw (error);
      }
    }
    await retrieveUser();

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _accessToken = null;
    _accountId = null;
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> retrieveUser() async {
    final url = 'authenticated/me';
    final responseData = await _apiHelper.getProtected(url, _accessToken);
    myProfile = Profile.fromJson(responseData);
    _accountId = responseData['accountId'].toString();
    _username = responseData['email'].toString();
    print(myProfile.uuid);
    await signInToFirebase();
    notifyListeners();
  }

  Future<void> signInToFirebase() async {
    await Firebase.initializeApp();

    final response = http
        .get(
            "${_apiHelper.baseUrl}authenticated/firebaseToken/${myProfile.uuid}",
            headers: {
          "Authorization": "Bearer $accessToken"
        }).then((value) => {
              FirebaseAuth.instance
                  .signInWithCustomToken(value.body)
                  .then((userInfo) => {
                        if (userInfo.additionalUserInfo.isNewUser)
                          {
                            Firestore.instance
                                .collection("users")
                                .doc(myProfile.uuid)
                                .set({
                              "name": myProfile.name,
                              "email": myProfile.email,
                              "uid": myProfile.uuid,
                              "groups": []
                            })
                          }
                      })
            });
  }
}
