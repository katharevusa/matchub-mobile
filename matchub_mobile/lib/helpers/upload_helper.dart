import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

uploadSinglePic(File file, String url, String accessToken, String paramName,
    context) async {
  var request = new http.MultipartRequest("POST", Uri.parse(url));
  request.headers.addAll({"Authorization": "Bearer " + accessToken});
  request.files.add(http.MultipartFile.fromBytes(
      paramName, file.readAsBytesSync(),
      filename: file.path));
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
    String paramName, context) async {
  var request = new http.MultipartRequest("POST", Uri.parse(url));
  request.headers.addAll({"Authorization": "Bearer " + accessToken});
  files.forEach((element) {
    request.files.add(http.MultipartFile.fromBytes(
        paramName, element.readAsBytesSync(),
        filename: element.path));
  });
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      var res = json.decode(value) as Map<String, dynamic>;
    });
  }).catchError((e) {
    print(e);
  });
}
