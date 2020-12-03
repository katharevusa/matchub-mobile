import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/screens/project/projectCreation/badge_creation.dart';
import 'package:matchub_mobile/screens/project/projectCreation/basic_information.dart';
import 'package:matchub_mobile/screens/project/projectCreation/dateTime.dart';
import 'package:matchub_mobile/screens/project/projectCreation/keyword.dart';
import 'package:matchub_mobile/screens/project/projectCreation/sdg.dart';
import 'package:matchub_mobile/screens/resource/resource_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:matchub_mobile/helpers/upload_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';

class ProjectCreationScreen extends StatefulWidget {
  static const routeName = "/project-creation-screen";
  Project newProject;
  ProjectCreationScreen({this.newProject});
  @override
  _ProjectCreationScreenState createState() => _ProjectCreationScreenState();
}

class _ProjectCreationScreenState extends State<ProjectCreationScreen> {
  _ProjectCreationScreenState();
  Map<String, dynamic> project;
  List<File> coverPhoto = [];
  List<File> photos = [];
  List<File> documents = [];
  @override
  void initState() {
    if (widget.newProject == null) {
      widget.newProject = Project();
    }
    project = {
      "projectId": widget.newProject.projectId,
      "projectTitle": widget.newProject.projectTitle ?? "",
      "projectDescription": widget.newProject.projectDescription ?? "",
      "country": widget.newProject.country ?? "",
      "startDate": widget.newProject.startDate ?? DateTime.now(),
      "endDate": widget.newProject.endDate ?? DateTime.now(),
      "userFollowers": widget.newProject.userFollowers ?? [],
      "projStatus": widget.newProject.projStatus ?? "ON_HOLD",
      "upvotes": widget.newProject.upvotes ?? 0,
      "photos": widget.newProject.photos ?? [],
      "relatedResources": widget.newProject.relatedResources ?? [],
      "projCreatorId": widget.newProject.projCreatorId,
      "spotlight": widget.newProject.spotlight,
      "spotlightEndTime": widget.newProject.spotlightEndTime,
      "joinRequests": widget.newProject.joinRequests ?? [],
      "reviews": widget.newProject.reviews ?? [],
      "projectBadge": widget.newProject.projectBadge ?? "",
      "fundsCampaign": widget.newProject.fundsCampaign ?? [],
      "meetings": widget.newProject.meetings,
      "listOfRequests": widget.newProject.listOfRequests,
      "sdgs": widget.newProject.sdgs != null
          ? widget.newProject.sdgs.map((e) => e.sdgId).toList()
          : [],
      "kpis": widget.newProject.kpis,
      "teamMembers": widget.newProject.teamMembers,
      "channels": widget.newProject.channels,
      "projectOwners": widget.newProject.projectOwners ?? [],
      "badgeTitle": widget.newProject.projectBadge != null
          ? widget.newProject.projectBadge.badgeTitle
          : null,
      "badgeIcon": widget.newProject.projectBadge != null
          ? widget.newProject.projectBadge.icon
          : null,
      "badgeId": widget.newProject.projectBadge != null
          ? widget.newProject.projectBadge.badgeId
          : null,
    };
  }

  SwiperController _controller = SwiperController();
  int _currentIndex = 0;

  final List<String> titles_edit = [
    "Edit Project",
    "Edit Project",
    "Edit Project",
    "Edit Project",
    "Edit Project",
    "Edit Project",
    "Edit Project",
    "Edit Project",
    "Edit Project",
  ];

  final List<String> titles = [
    "Create New Project",
    "Create New Project",
    "Create New Project",
    "Create New Project",
    "Create New Project",
    "Create New Project",
    "Create New Project",
    "Create New Project",
    "Create New Project",
    "Create New Project",
  ];
  final List<String> subtitles = [
    "Basic Information",
    "Start Date & Time",
    "End Date & Time",
    "Select SDGs",
    "Select keyword",
    "Upload Cover Photo",
    "Upload Photo",
    "Upload Documents",
    "Badge",
    "Create Fund Campaign",
  ];
  final List<Color> colors = [
    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.indigo.shade300,
    Colors.deepOrange.shade300,
    Colors.pinkAccent.shade100,
    Colors.lime.shade300,
    Colors.brown.shade400,
    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.indigo.shade300,
    Colors.deepOrange.shade300,
  ];

  void createNewProject(context) async {
    project["projCreatorId"] = Provider.of<Auth>(context).myProfile.accountId;
    project["projectOwnerId"] = Provider.of<Auth>(context).myProfile.accountId;
    final url = "authenticated/createNewProject";
    var accessToken = Provider.of<Auth>(context).accessToken;
    var startProjectTime = project['startDate'];
    project['startDate'] = formatDate(
        DateTime(
            startProjectTime.year,
            startProjectTime.month,
            startProjectTime.day,
            startProjectTime.hour,
            startProjectTime.minute,
            startProjectTime.second),
        [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);
    var endProjectTime = project['endDate'];
    project['endDate'] = formatDate(
        DateTime(endProjectTime.year, endProjectTime.month, endProjectTime.day,
            endProjectTime.hour, endProjectTime.minute, endProjectTime.second),
        [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);

    File uploadedBadge = project['uploadedBadge'];
    project['uploadedBadge'] = null;

    try {
      final response = await ApiBaseHelper.instance.postProtected(url,
          accessToken: accessToken, body: json.encode(project));
      int newProjectId = response['projectId'];
      if (coverPhoto.isNotEmpty) {
        await uploadSinglePic(
          coverPhoto.first,
          "${ApiBaseHelper.instance.baseUrl}authenticated/updateProject/updateProjectProfilePic?projectId=${newProjectId}",
          Provider.of<Auth>(context, listen: false).accessToken,
          "profilePic",
        );
      }
      if (photos.isNotEmpty) {
        await uploadMultiFile(
          photos,
          "${ApiBaseHelper.instance.baseUrl}authenticated/updateProject/uploadPhotos?projectId=${newProjectId}",
          Provider.of<Auth>(context, listen: false).accessToken,
          "photos",
        );
      }
      if (documents.isNotEmpty) {
        await uploadMultiFile(
          documents,
          "${ApiBaseHelper.instance.baseUrl}authenticated/updateProject/uploadDocuments?projectId=${newProjectId}",
          Provider.of<Auth>(context, listen: false).accessToken,
          "documents",
        );
      }
      if (project['badgeTitle'] != null) {
        Map<String, dynamic> badge = {};
        badge['badgeTitle'] = project['badgeTitle'];
        badge['icon'] = project['badgeIcon'] ?? "";
        badge['projectId'] = newProjectId;

        Badge badgeResult =
            Badge.fromJson(await ApiBaseHelper.instance.postProtected(
          "authenticated/createProjectBadge",
          body: json.encode(badge),
        ));
        if (uploadedBadge != null) {
          await uploadSinglePic(
            uploadedBadge,
            "${ApiBaseHelper.instance.baseUrl}authenticated/projectBadge/uploadBadgeIcon/${badgeResult.badgeId}",
            Provider.of<Auth>(context, listen: false).accessToken,
            "icon",
          );
          // badge['icon'] = badgeResult.icon;

          // badgeResult = await ApiBaseHelper.instance.putProtected(
          //     "authenticated/updateProjectBadge/${badgeResult.badgeId}",
          //     body: json.encode(badge),
          //     accessToken:
          //         Provider.of<Auth>(context, listen: false).accessToken);
        }
      }
      /* if (project['badgeCustomisedIcon'] != null &&
          project['badgeTitle'] != null) {
        Map<String, dynamic> badge = {};

        badge['badgeTitle'] = project['badgeTitle'];
        badge['icon'] = project['badgeIcon'];

        badge['projectId'] = newProjectId;

        ApiBaseHelper.instance.postProtected("authenticated/createProjectBadge",
            body: json.encode(badge),
            accessToken: Provider.of<Auth>(context, listen: false).accessToken);
      }*/

      Provider.of<Auth>(context, listen: false).retrieveUser();
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      project['startDate'] = startProjectTime;
      project['endDate'] = endProjectTime;
      showErrorDialog(error.toString(), context);
    }
  }

  void updateProject(context) async {
    // if (!_formKey.currentState.validate()) {
    //   print("Form is invalid");
    //   return;
    // }
    // _formKey.currentState.save();

    var updaterId = Provider.of<Auth>(context).myProfile.accountId;
    var projectId = project["projectId"];
    final url =
        "authenticated/updateProject?updaterId=${updaterId}&projectId=${projectId}";
    var startProjectTime = project['startDate'];
    project['startDate'] = formatDate(
        DateTime(
            startProjectTime.year,
            startProjectTime.month,
            startProjectTime.day,
            startProjectTime.hour,
            startProjectTime.minute,
            startProjectTime.second),
        [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);
    var endProjectTime = project['endDate'];
    project['endDate'] = formatDate(
        DateTime(endProjectTime.year, endProjectTime.month, endProjectTime.day,
            endProjectTime.hour, endProjectTime.minute, endProjectTime.second),
        [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);

    File uploadedBadge = project['uploadedBadge'];
    project['uploadedBadge'] = null;

    try {
      var accessToken = Provider.of<Auth>(context).accessToken;
      final response = await ApiBaseHelper.instance.putProtected(url,
          accessToken: accessToken, body: json.encode(project));

      if (coverPhoto.isNotEmpty) {
        await uploadSinglePic(
          coverPhoto.first,
          "${ApiBaseHelper.instance.baseUrl}authenticated/updateProject/updateProjectProfilePic?projectId=${project['projectId']}",
          Provider.of<Auth>(context, listen: false).accessToken,
          "profilePic",
        );
      }
      if (photos.isNotEmpty) {
        await uploadMultiFile(
          photos,
          "${ApiBaseHelper.instance.baseUrl}authenticated/updateProject/uploadPhotos?projectId=${project['projectId']}",
          Provider.of<Auth>(context, listen: false).accessToken,
          "photos",
        );
      }
      if (documents.isNotEmpty) {
        await uploadMultiFile(
          photos,
          "${ApiBaseHelper.instance.baseUrl}authenticated/updateProject/uploadDocuments?projectId=${project['projectId']}",
          Provider.of<Auth>(context, listen: false).accessToken,
          "documents",
        );
      }
      if (project['badgeTitle'] != null) {
        Map<String, dynamic> badge = {};
        badge['badgeTitle'] = project['badgeTitle'];
        badge['icon'] = project['badgeIcon'] ?? "";
        badge['accountId'] =
            Provider.of<Auth>(context, listen: false).myProfile.accountId;
        Badge badgeResult = Badge.fromJson(await ApiBaseHelper.instance
            .putProtected(
                "authenticated/updateProjectBadge/${project['badgeId']}",
                body: json.encode(badge),
                accessToken:
                    Provider.of<Auth>(context, listen: false).accessToken));
        if (uploadedBadge != null) {
          await uploadSinglePic(
            uploadedBadge,
            "${ApiBaseHelper.instance.baseUrl}authenticated/projectBadge/uploadBadgeIcon/${badgeResult.badgeId}",
            Provider.of<Auth>(context, listen: false).accessToken,
            "icon",
          );
        }
      }
      Provider.of<Auth>(context).retrieveUser();
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      project['startDate'] = startProjectTime;
      project['endDate'] = endProjectTime;
      showErrorDialog(error.toString(), context);
      print("Failure");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Swiper(
                loop: false,
                index: _currentIndex,
                onIndexChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                controller: _controller,
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    activeColor: Colors.red,
                    activeSize: 20.0,
                  ),
                ),
                itemCount: project["projectId"] == null ? 9 : 7,
                itemBuilder: (context, index) {
                  if (index == 0 && project["projectId"] == null) {
                    return IntroItem(
                      title: titles[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Basic_information(project),
                    );
                  } else if (index == 0 && project["projectId"] != null) {
                    return IntroItem(
                      title: titles_edit[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Basic_information(project),
                    );
                  } else if (index == 1 && project["projectId"] == null) {
                    return IntroItem(
                      title: titles[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Start(project),
                    );
                  } else if (index == 1 && project["projectId"] != null) {
                    return IntroItem(
                      title: titles_edit[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Start(project),
                    );
                  } else if (index == 2 && project["projectId"] == null) {
                    return IntroItem(
                      title: titles[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: End(project),
                    );
                  } else if (index == 2 && project["projectId"] != null) {
                    return IntroItem(
                      title: titles_edit[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: End(project),
                    );
                  } else if (index == 3 && project["projectId"] == null) {
                    return IntroItem(
                      title: titles[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: SDG(project),
                    );
                  } else if (index == 4 && project["projectId"] != null) {
                    return IntroItem(
                      title: titles_edit[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Keywords(project),
                    );
                  } else if (index == 4 && project["projectId"] == null) {
                    return IntroItem(
                      title: titles[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Keywords(project),
                    );
                  } else if (index == 3 && project["projectId"] != null) {
                    return IntroItem(
                      title: titles_edit[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: SDG(project),
                    );
                  } else if (index == 5 && project["projectId"] == null) {
                    return IntroItem(
                        title: titles[index],
                        subtitle: subtitles[index],
                        bg: colors[index],
                        widget: Document(project, false, false, coverPhoto));
                  } else if (index == 5 && project["projectId"] != null) {
                    return IntroItem(
                        title: titles_edit[index],
                        subtitle: subtitles[index],
                        bg: colors[index],
                        widget: Document(project, false, false, coverPhoto));
                  } else if (index == 6 && project["projectId"] == null) {
                    return IntroItem(
                        title: titles[index],
                        subtitle: subtitles[index],
                        bg: colors[index],
                        widget: Document(project, true, false, photos));
                    // } else if (index == 5 && project["projectId"] != null) {
                    //   return IntroItem(
                    //       title: titles_edit[index],
                    //       subtitle: subtitles[index],
                    //       bg: colors[index],
                    //       widget: Document(project, true, false, photos));
                  } else if (index == 7 && project["projectId"] == null) {
                    return IntroItem(
                        title: titles[index],
                        subtitle: subtitles[index],
                        bg: colors[index],
                        widget: Document(project, true, true, documents));
                  } else if (index == 6 && project["projectId"] != null) {
                    return IntroItem(
                        title: titles_edit[index],
                        subtitle: subtitles[index],
                        bg: colors[index],
                        widget: BadgeCreation(project));
                  } else if (index == 8 && project["projectId"] == null) {
                    return IntroItem(
                        title: titles[index],
                        subtitle: subtitles[index],
                        bg: colors[index],
                        widget: BadgeCreation(project));
                  }
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                child: Text("Skip"),
                onPressed: () {
                  _controller.next();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(((_currentIndex == 8 &&
                            project["projectId"] == null) ||
                        (_currentIndex == 6 && project["projectId"] != null))
                    ? Icons.check
                    : Icons.arrow_forward),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (project["projectId"] == null) {
                    if (_currentIndex != 8) {
                      _controller.next();
                    } else {
                      createNewProject(context);
                    }
                  } else {
                    if (_currentIndex != 6)
                      _controller.next();
                    else {
                      updateProject(context);
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Document extends StatefulWidget {
  Map<String, dynamic> project;
  bool toUploadMultiple;
  bool toUploadDocuments = false;
  List<File> fileList = new List<File>();

  Document(this.project, this.toUploadMultiple, this.toUploadDocuments,
      this.fileList);
  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  List<Widget> fileListThumbnail;
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
        widget.fileList.add(file);
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
    widget.fileList.forEach((file) => fileListThumbnail.add(Container(
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
    if (!(widget.fileList.isNotEmpty && !widget.toUploadMultiple))
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: filesarebeingpicked,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? SingleChildScrollView(
                      child: Column(children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 1,
                        crossAxisCount: 4,
                        children: fileListThumbnail,
                      ),
                      if (widget.fileList.isNotEmpty)
                        FlatButton(
                          onPressed: () async {
                            setState(() {
                              fileListThumbnail.clear();
                              widget.fileList.clear();
                            });
                          },
                          child: Text("Clear",
                              style: TextStyle(color: Colors.red[400])),
                        )
                    ]))
                  : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
// await FilePicker.getMultiFile(
//   type: FileType.custom,
//   allowedExtensions: ['pdf'],
// ).then((files) {
//   if (files != null && files.length > 0) {
//     files.forEach((element) {
//       List<String> picExt = ['.jpg', '.jpeg', '.bmp'];

//       if (picExt.contains(extension(element.path))) {
//         thumbs.add(Padding(
//             padding: EdgeInsets.all(1), child: new Image.file(element)));
//       } else
//         thumbs.add(Container(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//               Icon(Icons.insert_drive_file),
//               Text(basename(element.path)),
//             ])));
//       fileList.add(element);
//       // widget.newResource.uploadedFiles.add(element.toString());
//       // print(widget.newResource.uploadedFiles.toList());
//     });
//     setState(() {
//       fileListThumbnail = thumbs;
//     });
//   }
// }

// List<Map> storeNameAndPath(List<File> fileList) {
//   List<Map> s = new List<Map>();
//   if (fileList.length > 0)
//     fileList.forEach((element) {
//       Map a = {
//         'fileName': basename(element.path),
//         'encoded': base64Encode(element.readAsBytesSync())
//       };
//       s.add(a);
//     });
//   return s;
// }

class IntroItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bg;
  final Widget widget;

  const IntroItem({
    Key key,
    @required this.title,
    this.subtitle,
    this.bg,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg ?? Theme.of(context).primaryColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: Colors.white),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 5.0),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 10.0),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Material(
                        elevation: 4.0,
                        child: widget,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
