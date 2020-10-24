import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/upload_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UploadVerificationDocument extends StatefulWidget {
  Function updateProfile;
  final Map<String, dynamic> profile;
  PageController controller;
  bool toUploadMultiple = true;
  bool toUploadDocuments = false;
  //List<File> documents = [];

  UploadVerificationDocument(this.profile, this.controller, this.updateProfile);

  @override
  _UploadVerificationDocumentState createState() =>
      _UploadVerificationDocumentState();
}

class _UploadVerificationDocumentState
    extends State<UploadVerificationDocument> {
  List<Widget> fileListThumbnail;
  List<File> documents = [];
  List<File> fileList = new List<File>();
  Future filesarebeingpicked = Future.delayed(Duration(microseconds: 1));

  Future pickFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.toUploadDocuments
          ? ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'xlsx']
          : ['jpg', 'png'],
      allowMultiple: widget.toUploadMultiple,
    );

    if (result != null) {
      setState(() {});
      result.files.forEach((element) {
        File file = (File(element.path));

        print(element.name);
        print(element.bytes);
        print(element.size);
        print(element.extension);
        print(element.path);
        fileList.add(file);
        fileListThumbnail.add(Container(
          padding: EdgeInsets.all(8),
          height: 200,
          width: 200,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.insert_drive_file),
                Expanded(
                    child: Text(
                  basename(file.path),
                  overflow: TextOverflow.fade,
                ))
              ]),
        ));
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    fileListThumbnail = [];
    fileList.forEach((file) => fileListThumbnail.add(Container(
          padding: EdgeInsets.all(8),
          height: 200,
          width: 200,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.insert_drive_file),
                Expanded(
                    child: Text(
                  basename(file.path),
                  overflow: TextOverflow.fade,
                ))
              ]),
        )));
    if (!(fileList.isNotEmpty && !widget.toUploadMultiple))
      fileListThumbnail.add(InkWell(
        onTap: () {
          filesarebeingpicked = pickFiles();
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[400], width: 2.0)),
            height: 200,
            width: 200,
            child: Center(child: Icon(Icons.add))),
      ));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: filesarebeingpicked,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? SingleChildScrollView(
                      child: Column(children: [
                      SizedBox(height: 10),
                      Text(
                        "Upload files for verification",
                        style: AppTheme.titleLight,
                      ),
                      SizedBox(height: 10),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 1,
                        crossAxisCount: 4,
                        children: fileListThumbnail,
                      ),
                      if (fileList.isNotEmpty)
                        FlatButton(
                          onPressed: () async {
                            setState(() {
                              fileListThumbnail.clear();
                              fileList.clear();
                            });
                          },
                          child: Text("Clear",
                              style: TextStyle(color: Colors.red[400])),
                        )
                    ]))
                  : Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("4/4", style: TextStyle(color: Colors.grey)),
            ),
            RaisedButton(
                color: kSecondaryColor,
                onPressed: () async {
                  if (fileList.isNotEmpty) {
                    await uploadMultiFile(
                        fileList,
                        "${ApiBaseHelper.instance.baseUrl}public/setupOrganisationProfile/uploadDocuments/${Provider.of<Auth>(context, listen: false).myProfile.uuid}",
                        Provider.of<Auth>(context, listen: false).accessToken,
                        "files",
                      );
                  }
                  widget.updateProfile(
                      Provider.of<Auth>(context,listen: false).accessToken, context);
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
