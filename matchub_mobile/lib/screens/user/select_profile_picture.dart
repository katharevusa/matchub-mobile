import 'dart:io';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/upload_helper.dart';
import 'package:http/http.dart' as http;
import 'package:matchub_mobile/widgets/popupmenubutton.dart' as popupmenu;
import 'package:matchub_mobile/sizeConfig.dart';
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
              Stack(
                children: [
                  Container(
                    height: SizeConfig.widthMultiplier * 100,
                    width: SizeConfig.widthMultiplier * 100,
                    color: Colors.grey[300].withOpacity(0.8),
                    child: Center(
                      child: (pickedProfilePic == null &&
                              myProfile.profilePhoto.isNotEmpty)
                          ? AttachmentImage(myProfile.profilePhoto)
                          : (pickedProfilePic != null)
                              ? Image.file(
                                  pickedProfilePic,
                                  fit: BoxFit.cover,
                                  height: SizeConfig.widthMultiplier * 100,
                                  width: SizeConfig.widthMultiplier * 100,
                                )
                              : Text(
                                  "${myProfile.firstName.substring(0, 1).toUpperCase() + myProfile.lastName.substring(0, 1).toUpperCase()}",
                                  style: TextStyle(fontSize: 40),
                                ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 10,
                    child: popupmenu.PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.more_vert_rounded,
                          size: 24,
                          color: Colors.grey[900],
                        ),
                        itemBuilder: (BuildContext context) => [
                              popupmenu.PopupMenuItem(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () async {
                                    FilePickerResult result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'png'],
                                    );

                                    if (result != null) {
                                      setState(() {
                                        pickedProfilePic =
                                            File(result.files.single.path);
                                      });
                                      PlatformFile file = result.files.first;
                                    }
                                  },
                                  dense: true,
                                  leading: Icon(Icons.file_upload),
                                  title: Text(
                                    "Set Profile Photo",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.8),
                                  ),
                                ),
                              ),
                              popupmenu.PopupMenuItem(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () async {
                                    await ApiBaseHelper.instance.deleteProtected(
                                        "authenticated/deleteProfilePict/${myProfile.accountId}",
                                        accessToken: Provider.of<Auth>(context)
                                            .accessToken);
                                    pickedProfilePic = null;
                                    setState(() {
                                      myProfile.profilePhoto = "";
                                    });
                                  },
                                  dense: true,
                                  leading: Icon(
                                    FlutterIcons.trash_alt_faw5s,
                                  ),
                                  title: Text(
                                    "Remove Profile Picture",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.8),
                                  ),
                                ),
                              ),
                            ]),
                  )
                ],
              ),
              SizedBox(height: 20),
              // Text(
              //   "You do not currently have a profile picture",
              //   style: TextStyle(fontSize: 16, color: Colors.grey[850]),
              // ),
              // SizedBox(height: 20),
              Text(
                "Profile Picture",
                style: AppTheme.titleLight,
              ),
              // SizedBox(height: 20),
              // SizedBox(height: 20),
              // ],
              //   if (pickedProfilePic == null &&
              //     myProfile.profilePhoto.isEmpty) ...[
              // if (pickedProfilePic == null &&
              //     myProfile.profilePhoto.isNotEmpty) ...[
              //   ClipOval(
              //       child: Container(
              //           height: 200,
              //           width: 200,
              //           child: AttachmentImage(myProfile.profilePhoto))),
              // SizedBox(height: 20),
              // RaisedButton(
              //   color: Colors.red[300],
              //   elevation: 2,
              //   visualDensity: VisualDensity.comfortable,
              //   child: Text("Remove Profile Picture"),
              //   onPressed: () async {
              //     await ApiBaseHelper.instance.deleteProtected(
              //         "authenticated/deleteProfilePict/${myProfile.accountId}",
              //         accessToken: Provider.of<Auth>(context).accessToken);
              //     setState(() {
              //       myProfile.profilePhoto = "";
              //     });
              //   },
              // ),
              SizedBox(height: 20),
            ],
            // if (pickedProfilePic != null)
            //   ClipOval(
            //     // borderRadius: BorderRadius.circular(50),
            //     child: Container(
            //         height: 200,
            //         width: 200,
            //         child: Image.file(
            //           pickedProfilePic,
            //           fit: BoxFit.cover,
            //         )),
            //   ),
            // SizedBox(height: 20),
            // GestureDetector(
            //   onTap: () async {
            //     FilePickerResult result = await FilePicker.platform.pickFiles(
            //       type: FileType.custom,
            //       allowedExtensions: ['jpg', 'png'],
            //     );

            //     if (result != null) {
            //       setState(() {
            //         pickedProfilePic = File(result.files.single.path);
            //       });
            //       PlatformFile file = result.files.first;
            //     }
            //   },
            // child: Container(
            //     height: 100,
            //     width: 100,
            //     decoration: BoxDecoration(
            //         color: Colors.grey[200],
            //         borderRadius: BorderRadius.circular(10),
            //         border:
            //             Border.all(color: Colors.grey[400], width: 2.0)),
            //     child: Center(child: Icon(Icons.file_upload))),
            // ),
            // ],
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
                      "${ApiBaseHelper.instance.baseUrl}authenticated/updateIndividual/updateProfilePic/${Provider.of<Auth>(context, listen: false).myProfile.uuid}",
                      Provider.of<Auth>(context, listen: false).accessToken,
                      'file',
                    );
                  }
                  widget.updateProfile(
                      Provider.of<Auth>(context).accessToken, context);
                  // widget.controller.animateToPage(3,
                  //     curve: Curves.decelerate,
                  //     duration: Duration(milliseconds: 800));
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
  //           "${ApiBaseHelper.instance.baseUrl}authenticated/updateIndividual/updateProfilePic/${Provider.of<Auth>(context).myProfile.uuid}"));
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
