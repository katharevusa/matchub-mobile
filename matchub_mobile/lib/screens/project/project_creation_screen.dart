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
import 'package:matchub_mobile/screens/resource/resource_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:date_format/date_format.dart';

class ProjectCreationScreen extends StatefulWidget {
  static const routeName = "/project-creation-screen";
  Project newProject;
  ProjectCreationScreen({this.newProject});
  @override
  _ProjectCreationScreenState createState() =>
      _ProjectCreationScreenState(newProject);
}

class _ProjectCreationScreenState extends State<ProjectCreationScreen> {
  Project newProject;
  _ProjectCreationScreenState(this.newProject);
  Map<String, dynamic> project;
  @override
  void initState() {
    project = {
      "projectId": newProject.projectId,
      "projectTitle": newProject.projectTitle ?? "",
      "projectDescription": newProject.projectDescription ?? "",
      "country": newProject.country ?? "",
      "startDate": newProject.startDate ?? "",
      "endDate": newProject.endDate ?? "",
      "userFollowers": newProject.userFollowers ?? [],
      "projStatus": newProject.projStatus ?? "ON_HOLD",
      "upvotes": newProject.upvotes ?? 0,
      "photos": newProject.photos ?? [],
      "relatedResources": newProject.relatedResources ?? [],
      "projCreatorId": newProject.projCreatorId,
      "spotlight": newProject.spotlight,
      "spotlightEndTime": newProject.spotlightEndTime,
      "joinRequests": newProject.joinRequests ?? [],
      "reviews": newProject.reviews ?? [],
      "projectBadge": newProject.projectBadge,
      "fundsCampaign": newProject.fundsCampaign ?? [],
      "meetings": newProject.meetings,
      "listOfRequests": newProject.listOfRequests,
      "sdgIds": newProject.sdgs != null
          ? newProject.sdgs.map((e) => e.sdgId).toList()
          : [],
      "kpis": newProject.kpis,
      "teamMembers": newProject.teamMembers,
      "channels": newProject.channels,
      "projectOwners": newProject.projectOwners ?? [],
    };
  }

  SwiperController _controller = SwiperController();
  int _currentIndex = 0;

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
  ];
  final List<String> subtitles = [
    "Basic Information",
    "Start Date & Time",
    "End Date & Time",
    "Select SDGs",
    "Upload Profile photo",
    "Upload Photo",
    "Upload Documents",
    "Badge Creation",
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
  ];

  void createNewProject(context) async {
    project["projCreatorId"] = Provider.of<Auth>(context).myProfile.accountId;
    project["projectOwnerId"] = Provider.of<Auth>(context).myProfile.accountId;
    final url = "authenticated/createNewProject";
    var accessToken = Provider.of<Auth>(context).accessToken;
    try {
      final response = await ApiBaseHelper().postProtected(url,
          accessToken: accessToken, body: json.encode(project));
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      final responseData = error.body as Map<String, dynamic>;
      print("Failure");
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(responseData['error']),
                content: Text(responseData['message']),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => ResourceScreen()));
                    },
                  )
                ],
              ));
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
    try {
      var accessToken = Provider.of<Auth>(context).accessToken;
      final response = await ApiBaseHelper().putProtected(url,
          accessToken: accessToken, body: json.encode(project));
      Provider.of<Auth>(context).retrieveUser();
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      final responseData = error.body as Map<String, dynamic>;
      print("Failure");
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(responseData['error']),
                content: Text(responseData['message']),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Swiper(
              loop: false,
              // physics: NeverScrollableScrollPhysics(),
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
              itemCount: 9,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Basic_information(project),
                  );
                } else if (index == 1) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Start(project),
                  );
                } else if (index == 2) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: End(project),
                  );
                } else if (index == 3) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: SDG(project),
                  );
                } else if (index == 4) {
                  return IntroItem(
                      title: titles[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Document(project));
                } else if (index == 5) {
                  return IntroItem(
                      title: titles[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Document(project));
                } else if (index == 6) {
                  return IntroItem(
                      title: titles[index],
                      subtitle: subtitles[index],
                      bg: colors[index],
                      widget: Document(project));
                } else if (index == 7) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    // widget: Badge(project),
                  );
                } else if (index == 8) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    //    widget: FundCampaign(project),
                  );
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
              icon:
                  Icon(_currentIndex == 8 ? Icons.check : Icons.arrow_forward),
              onPressed: () {
                if (_currentIndex != 8) {
                  _controller.next();
                }
                // if (_currentIndex != 5)
                //   _controller.next();
                else if (project["projectId"] == null) {
                  createNewProject(context);
                } else {
                  updateProject(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class Basic_information extends StatefulWidget {
  Map<String, dynamic> project;
  Basic_information(this.project);

  @override
  _Basic_informationState createState() => _Basic_informationState();
}

class _Basic_informationState extends State<Basic_information> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();
    _titleController.text = widget.project["projectTitle"];
    _descriptionController.text = widget.project["projectDescription"];
    widget.project["country"] = "Singapore";
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(hintText: 'Title'),
                controller: _titleController,
                autofocus: true,
                onChanged: (text) {
                  if (text != null) {
                    widget.project["projectTitle"] = text;
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(hintText: 'Description'),
                controller: _descriptionController,
                autofocus: true,
                onChanged: (text) {
                  widget.project["projectDescription"] = text;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Select country",
                    style: TextStyle(fontSize: 17),
                  ),
                  CountryListPick(
                      isShowFlag: true,
                      isShowTitle: true,
                      isDownIcon: true,
                      showEnglishName: true,
                      initialSelection: '+65',
                      buttonColor: Colors.transparent,
                      onChanged: (CountryCode code) {
                        widget.project["country"] = code.name;
                      }),
                ],
              ),
            )
          ],
        )));
  }
}

class Start extends StatefulWidget {
  Map<String, dynamic> project;
  Start(this.project);
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print(widget.project["startDate"]);
    if (widget.project["startDate"] != "" &&
        widget.project["startDate"] != null) {
      dateTime = DateTime.parse(widget.project["startDate"]);
      // dateTime = widget.project["startDate"];
    }
    if (widget.project["startDate"] == "" ||
        widget.project["startDate"] == null) {
      widget.project["startDate"] = formatDate(
          DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour,
              dateTime.minute, dateTime.second),
          [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);
    }
    return Column(
      children: <Widget>[
        Text(
          DateFormat.yMMMd().add_jm().format(dateTime),
        ),
        Container(
          height: 300,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: dateTime,
            onDateTimeChanged: (newDateTime) {
              setState(() {
                dateTime = newDateTime;
                print(dateTime);
                widget.project["startDate"] = formatDate(
                    DateTime(dateTime.year, dateTime.month, dateTime.day,
                        dateTime.hour, dateTime.minute, dateTime.second),
                    [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);

                print(widget.project["startDate"]);
              });
            },
          ),
        ),
      ],
    );
  }
}

class End extends StatefulWidget {
  Map<String, dynamic> project;
  End(this.project);
  @override
  _EndState createState() => _EndState();
}

class _EndState extends State<End> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (widget.project["endDate"] != "" && widget.project["endDate"] != null) {
      dateTime = DateTime.parse(widget.project["endDate"]);
      // dateTime = widget.project["endDate"];
    }

    return Column(
      children: <Widget>[
        Text(
          DateFormat.yMMMd().add_jm().format(dateTime),
        ),
        Container(
          height: 300,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: dateTime,
            onDateTimeChanged: (newDateTime) {
              setState(() {
                dateTime = newDateTime;
                print(dateTime);
                widget.project["endDate"] = formatDate(
                    DateTime(dateTime.year, dateTime.month, dateTime.day,
                        dateTime.hour, dateTime.minute, dateTime.second),
                    [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);

                print("hello");
                print(widget.project["endDate"]);
              });
            },
          ),
        ),
      ],
    );
  }
}

class SDG extends StatefulWidget {
  Map<String, dynamic> project;
  SDG(this.project);

  @override
  _SDGState createState() => _SDGState();
}

class _SDGState extends State<SDG> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(SDGPicker.routeName)
                  .then((value) {
                setState(() {
                  if (value != null) {
                    widget.project['sdgIds'].addAll(value);
                  }
                  widget.project['sdgIds'] =
                      widget.project['sdgIds'].toSet().toList();
                  //    print(widget.project['sdgIds']);
                });
              });
            },
            child: Container(
              constraints:
                  BoxConstraints(minHeight: 20 * SizeConfig.heightMultiplier),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey[850]),
                  )),
              child: Center(
                  child: Column(
                children: [
                  Text("Select your SDG(s)", style: AppTheme.titleLight),
                  if (widget.project['sdgIds'] != null) ...[
                    SizedBox(height: 5),
                    Text(
                      "${widget.project['sdgIds'].length} SDG(s) chosen",
                    )
                  ]
                ],
              )),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
    /*  return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(SDGPicker.routeName)
                  .then((value) {
                setState(() {
                  if (value != null) {
                    widget.project['sdgIds'].addAll(value);
                    //   print(widget.project['sdgsIds']);
                  }
                  widget.project['sdgIds'] =
                      widget.project['sdgIds'].toSet().toList();
                });
              });
            },
            child: Container(
              constraints:
                  BoxConstraints(minHeight: 25 * SizeConfig.heightMultiplier),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey[850]),
                  )),
              child: Center(
                  child: Column(
                children: [
                  Text("Select your SDG(s)", style: AppTheme.titleLight),
                  if (widget.project['sdgsIds'] != null) ...[
                    SizedBox(height: 5),
                    Text(
                      "${widget.project['sdgsIds'].length} SDG(s) chosen",
                    )
                  ]
                ],
              )),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );*/
  }
}

class Document extends StatefulWidget {
  Map<String, dynamic> resource;
  Document(this.resource);
  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  List<Widget> fileListThumb;
  List<File> fileList = new List<File>();

  Future pickFiles() async {
    List<Widget> thumbs = new List<Widget>();
    fileListThumb.forEach((element) {
      thumbs.add(element);
    });

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
    //       fileListThumb = thumbs;
    //     });
    //   }
    // });
  }

  List<Map> storeNameAndPath(List<File> fileList) {
    List<Map> s = new List<Map>();
    if (fileList.length > 0)
      fileList.forEach((element) {
        Map a = {
          'fileName': basename(element.path),
          'encoded': base64Encode(element.readAsBytesSync())
        };
        s.add(a);
      });
    return s;
  }

  @override
  Widget build(BuildContext context) {
    if (fileListThumb == null)
      fileListThumb = [
        InkWell(
          onTap: pickFiles,
          child: Container(child: Icon(Icons.add)),
        )
      ];
    // if(!resource.uploadedFiles.isEmpty){
    //   fileListThumb
    // }
    final Map params = new Map();
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: GridView.count(
                crossAxisCount: 4,
                children: fileListThumb,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

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
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                    color: Colors.white),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 20.0),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 40.0),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 70),
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
    );
  }
}