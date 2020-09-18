import 'dart:io';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/upload_helper.dart';
import 'package:http/http.dart' as http;
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/services/auth.dart';

class ProfilePhotoPicker extends StatefulWidget {
  Function updateProfile;
  final Map<String, dynamic> profile;
  PageController controller;

  ProfilePhotoPicker(this.profile, this.controller, this.updateProfile);

  @override
  _ProfilePhotoPickerState createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends State<ProfilePhotoPicker> {
  File pickedProfilePic;
  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context).myProfile;
    print(myProfile.profilePhoto);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          width: 100 * SizeConfig.widthMultiplier,
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Profile Picture",
                style: AppTheme.titleLight,
              ),
              SizedBox(height: 20),
              if (pickedProfilePic == null &&
                  myProfile.profilePhoto.isEmpty) ...[
                Text(
                  "You do not currently have a profile picture",
                  style: TextStyle(fontSize: 16, color: Colors.grey[850]),
                ),
                SizedBox(height: 20),
                ClipOval(
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        "${myProfile.name.substring(0, 1)}",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
              if (pickedProfilePic == null &&
                  myProfile.profilePhoto.isNotEmpty) ...[
                ClipOval(
                    child: Container(
                        height: 200,
                        width: 200,
                        child: AttachmentImage(myProfile.profilePhoto))),
                SizedBox(height: 20),
                RaisedButton(
                  color: Colors.red[300],
                  elevation: 2,
                  visualDensity: VisualDensity.comfortable,
                  child: Text("Remove Profile Picture"),
                  onPressed: () async {
                    await ApiBaseHelper().deleteProtected(
                        "authenticated/deleteProfilePict/${myProfile.accountId}",
                        accessToken: Provider.of<Auth>(context).accessToken);
                    setState(() {
                      myProfile.profilePhoto = "";
                    });
                  },
                ),
                SizedBox(height: 20),
              ],
              if (pickedProfilePic != null)
                ClipOval(
                  // borderRadius: BorderRadius.circular(50),
                  child: Container(
                      height: 200,
                      width: 200,
                      child: Image.file(
                        pickedProfilePic,
                        fit: BoxFit.cover,
                      )),
                ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  FilePickerResult result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png'],
                  );

                  if (result != null) {
                    setState(() {
                      pickedProfilePic = File(result.files.single.path);
                    });
                    PlatformFile file = result.files.first;

                    print(file.name);
                    print(file.bytes);
                    print(file.size);
                    print(file.extension);
                    print(file.path);
                    // print("==================" + result.count.toString());
                  }
                },
                child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.grey[400], width: 2.0)),
                    child: Center(child: Icon(Icons.file_upload))),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("3/3", style: TextStyle(color: Colors.grey)),
            ),
            RaisedButton(
                color: kSecondaryColor,
                onPressed: () async {
                  if (pickedProfilePic != null) {
                    await uploadSinglePic(
                        pickedProfilePic,
                        "${ApiBaseHelper().baseUrl}authenticated/updateIndividual/updateProfilePic/${Provider.of<Auth>(context, listen: false).myProfile.uuid}",
                        Provider.of<Auth>(context, listen: false).accessToken,
                        'file',
                        context);
                  }
                  widget.updateProfile(
                      Provider.of<Auth>(context).accessToken, context);
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }

  // uploadProfilePic(File file, url, context) async {

  //   var request = new http.MultipartRequest(
  //       "POST",
  //       Uri.parse(
  //           "${ApiBaseHelper().baseUrl}authenticated/updateIndividual/updateProfilePic/${Provider.of<Auth>(context).myProfile.uuid}"));
  //   request.headers.addAll(
  //       {"Authorization": "Bearer " + Provider.of<Auth>(context).accessToken});
  //   request.files.add(await http.MultipartFile.fromBytes(
  //       'file', file.readAsBytesSync(),
  //       filename: file.path));
  //   await request.send().then((response) async {
  //     response.stream.transform(utf8.decoder).listen((value) {
  //       print(value);
  //       var res = json.decode(value) as Map<String, dynamic>;
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
}
