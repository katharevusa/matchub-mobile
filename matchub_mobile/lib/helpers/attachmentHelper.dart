import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matchub_mobile/screens/kanban/task/viewTask.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class AttachmentPopup extends StatefulWidget {
  const AttachmentPopup({
    Key key,
  }) : super(key: key);

  @override
  _AttachmentPopupState createState() => _AttachmentPopupState();
}

class _AttachmentPopupState extends State<AttachmentPopup> {
  File _attachment;
  final picker = ImagePicker();

  Future getImage({isPhoto = true}) async {
    PickedFile pickedFile;
    if (isPhoto) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getVideo(source: ImageSource.camera);
    }

    setState(() {
      if (pickedFile != null) {
        _attachment = File(pickedFile.path);
        Navigator.pop(context, _attachment);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'ppt',
          'pptx',
          'doc',
          'docx',
          'xlsx',
          'jpg',
          'png'
        ]);
    if (result != null) {
      setState(() {
        _attachment = File(result.files.single.path);
      });
      Navigator.pop(context, _attachment);
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text("Attachment",
              style: TextStyle(
                  fontSize: 2.4 * SizeConfig.textMultiplier,
                  color: Colors.grey[850])),
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
            height: 4,
          ),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var attachmentTypes = [
              ListTile(
                leading: Icon(Icons.attach_file_rounded),
                title: Text("Choose document"),
                onTap: () => getDocument(),
              ),
              ListTile(
                leading: Icon(Icons.photo_library_outlined),
                title: Text("Record video"),
                onTap: () => getImage(isPhoto: false),
              ),
              ListTile(
                leading: Icon(Icons.add_a_photo_rounded),
                title: Text("Take photo"),
                onTap: () => getImage(),
              ),
            ];
            return attachmentTypes[index];
          },
          itemCount: 3,
        ),
      ],
    );
  }
}

Widget getDocumentImage(String fileName) {
  int ext = 0;
  switch (path.extension(fileName)) {
    case '.docx':
      {
        ext = 0;
      }
      break;
    case '.doc':
      {
        ext = 0;
      }
      break;
    case '.ppt':
      {
        ext = 1;
      }
      break;
    case '.xlsx':
      {
        ext = 2;
      }
      break;
    case '.pdf':
      {
        ext = 3;
      }
      break;
    default:
      ext = 4;
  }
  return Image.asset(
    iconList[ext],
    fit: BoxFit.cover,
  );
}

final List<String> iconList = [
  "assets/icons/word.png",
  "assets/icons/ppt.png",
  "assets/icons/excel.png",
  "assets/icons/pdf.png",
  "assets/icons/video.png",
];

class UploadImagePopup extends StatefulWidget {
  const UploadImagePopup({
    Key key,
  }) : super(key: key);

  @override
  _UploadImagePopupState createState() => _UploadImagePopupState();
}

class _UploadImagePopupState extends State<UploadImagePopup> {
  List<File> _attachment = [];
  final picker = ImagePicker();

  Future getImage({isPhoto = true}) async {
    PickedFile pickedFile;
    if (isPhoto) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getVideo(source: ImageSource.camera);
    }

    setState(() {
      if (pickedFile != null) {
        _attachment.add(File(pickedFile.path));
        Navigator.pop(context, _attachment);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'png']);
    if (result != null) {
      setState(() {
        result.files.forEach((element) {
          File file = (File(element.path));
          _attachment.add(file);
        });
      });
      Navigator.pop(context, _attachment);
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text("Select Photo",
              style: TextStyle(
                  fontSize: 2.4 * SizeConfig.textMultiplier,
                  color: Colors.grey[850])),
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
            height: 4,
          ),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var attachmentTypes = [
              ListTile(
                leading: Icon(Icons.photo_library_outlined),
                title: Text("Choose from gallery"),
                onTap: () => getDocument(),
              ),
              ListTile(
                leading: Icon(Icons.add_a_photo_rounded),
                title: Text("Take photo"),
                onTap: () => getImage(),
              ),
            ];
            return attachmentTypes[index];
          },
          itemCount: 2,
        ),
      ],
    );
  }
}
