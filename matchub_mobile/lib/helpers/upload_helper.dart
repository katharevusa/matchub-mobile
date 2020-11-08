import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

uploadSinglePic(File file, String url, String accessToken, String paramName,
    ) async {
  var request = new http.MultipartRequest("POST", Uri.parse(url));
  request.headers.addAll({"Authorization": "Bearer " + accessToken});
  request.files.add(http.MultipartFile.fromBytes(
      paramName, file.readAsBytesSync(),
      filename: file.path.substring(58)));
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      var res = json.decode(value) as Map<String, dynamic>;
    });
  }).catchError((e) {
    print(e);
  });
}

uploadMultiFile(List<File> files, String url, String accessToken,
    String paramName,) async {
  var request = new http.MultipartRequest("POST", Uri.parse(url));
  request.headers.addAll({"Authorization": "Bearer " + accessToken});
  files.forEach((file) {
    request.files.add(http.MultipartFile.fromBytes(
        paramName, file.readAsBytesSync(),
        filename: file.path.substring(58)));
  });
  await request.send().then((response) async {
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    //   var res = json.decode(value) as Map<String, dynamic>;
    // });
    print("Successfully uploaded");
  }).catchError((e) {
    print(e);
  });
}

// addAttachment(context) {
//   showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
//       ),
//       context: context,
//       builder: (ctx) {}).then((value) => value;);
// }
