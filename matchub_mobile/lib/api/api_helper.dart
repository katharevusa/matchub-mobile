import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:matchub_mobile/helpers/extensions.dart';

class ApiBaseHelper {
  // final String _baseUrl = "https://192.168.72.136:8443/api/v1/";
  final String _baseUrl = "https://192.168.43.224:8443/api/v1/";
  static String accessToken;
  static IOClient client;

  ApiBaseHelper._privateConstructor();

  static ApiBaseHelper _instance = ApiBaseHelper._privateConstructor();

  factory ApiBaseHelper() {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    client = new IOClient(httpClient);
    return _instance;
  }
  static ApiBaseHelper get instance => _instance;

  String get item => null;
  String get baseUrl {
    return _baseUrl;
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    print(_baseUrl + url);
    try {
      final response = await client
          .get(
            _baseUrl + url,
          )
          .timeout(Duration(seconds: 10));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWODecode(String url, {String accessToken}) async {
    var responseJson;
    print(_baseUrl + url);
    if (accessToken == null) {
      accessToken = ApiBaseHelper.accessToken;
    }
    try {
      final response = await client.get(_baseUrl + url, headers: {
        "Authorization": "Bearer $accessToken"
      }).timeout(Duration(seconds: 10));
      //responseJson //= _returnResponse(response);
      print(response.body);
      return json.decode(response.body);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> getProtected(String url, {String accessToken}) async {
    var responseJson;
    print(_baseUrl + url);
    if (accessToken == null) {
      accessToken = ApiBaseHelper.accessToken;
    }
    try {
      final response = await client.get(_baseUrl + url, headers: {
        "Authorization": "Bearer $accessToken"
      }).timeout(Duration(seconds: 10));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {String body = ""}) async {
    var responseJson;
    print(_baseUrl + url);
    print(body);
    try {
      final response = await client.post(
        _baseUrl + url,
        body: body,
        headers: {
          "Authorization": "Basic cmVhY3QtZmx1dHRlci1tYXRjaHViOmlzNDEwMw==",
          "content-type": "application/json"
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postProtected(String url,
      {String body = "", String accessToken}) async {
    var responseJson;
    if (accessToken == null) {
      accessToken = ApiBaseHelper.accessToken;
    }
    print(_baseUrl + url);
    print(body);
    try {
      final response = await client.post(
        _baseUrl + url,
        body: body,
        headers: {
          "Authorization": "Bearer " + accessToken,
          "content-type": "application/json"
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putProtected(String url,
      {String body = "", String accessToken}) async {
    var responseJson;
    if (accessToken == null) {
      accessToken = ApiBaseHelper.accessToken;
    }
    print(_baseUrl + url);
    print(body);
    try {
      final response = await client.put(
        _baseUrl + url,
        body: body,
        headers: {
          "Authorization": "Bearer " + accessToken,
          "content-type": "application/json"
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> deleteProtected(String url, {String accessToken}) async {
    var responseJson;
    if (accessToken == null) {
      accessToken = ApiBaseHelper.accessToken;
    }
    print(_baseUrl + url);
    try {
      await client.delete(
        _baseUrl + url,
        headers: {
          "Authorization": "Bearer " + accessToken,
          "content-type": "application/json"
        },
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    print(response.statusCode);
    if (response.contentLength == 0) return;
    print(response.body);
    var responseJson =
        json.decode(response.body.toString()) as Map<String, dynamic>;
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        var errors;
        responseJson['errors'] != null
            ? errors = responseJson['errors'].join(", ").toString().capitalize
            : errors = "";
        var errorMsg;
        responseJson['errorMessage'] != null
            ? errorMsg = responseJson['errorMessage']
            : errorMsg = responseJson['error_description'];
        throw BadRequestException(errors + " " + errorMsg);
      case 404:
        throw BadRequestException(responseJson['errorMessage'].toString());
      case 409:
        throw BadRequestException(
            responseJson['errorMessage'].toString().capitalize);
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured with StatusCode : ${response.statusCode}');
    }
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
