import 'dart:collection';
import 'dart:convert';
import 'dart:io';

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
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:date_format/date_format.dart';

class ResourceCreationScreen extends StatefulWidget {
  static const routeName = "/resource-creation-screen";
  Resources newResource;
  ResourceCreationScreen({this.newResource});
  @override
  _ResourceCreationScreenState createState() => _ResourceCreationScreenState();
}

class _ResourceCreationScreenState extends State<ResourceCreationScreen> {
  Map<String, dynamic> resource;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    resource = {
      "resourceId": widget.newResource.resourceId,
      "resourceName": widget.newResource.resourceName ?? "",
      "resourceDescription": widget.newResource.resourceDescription ?? "",
      "uploadedFiles": widget.newResource.uploadedFiles ?? [],
      "available": widget.newResource.available ?? true,
      "startTime": widget.newResource.startTime ?? "",
      "endTime": widget.newResource.endTime ?? "",
      "listOfRequests": widget.newResource.listOfRequests ?? [],
      "resourceCategoryId": widget.newResource.resourceCategoryId,
      "resourceOwnerId": widget.newResource.resourceOwnerId,
      "units": widget.newResource.units ?? 0,
      "photos": widget.newResource.photos ?? [],
      "spotlight": widget.newResource.spotlight,
      "spotlightEndTime": widget.newResource.spotlightEndTime,
      "matchedProjectId": widget.newResource.matchedProjectId,
    };
  }

  SwiperController _controller = SwiperController();
  int _currentIndex = 0;

  final List<String> titles = [
    "Create New Resource",
    "Create New Resource",
    "Create New Resource",
    "Create New Resource",
    "Create New Resource",
    "Create New Resource",
    "Create New Resource",
  ];

  final List<String> titles_edit = [
    "Edit Resource",
    "Edit Resource",
    "Edit Resource",
    "Edit Resource",
    "Edit Resource",
    "Edit Resource",
    "Edit Resource",
  ];
  final List<String> subtitles = [
    "Title & Description",
    "Select Category",
    "Input your unit",
    "Start Date",
    "End Date",
    "Upload Photo",
    "Upload Documents",
  ];
  final List<Color> colors = [
    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.indigo.shade300,
    Colors.deepOrange.shade300,
    Colors.pinkAccent.shade100,
    Colors.lime.shade300,
    Colors.brown.shade400,
  ];

  void createNewResource(context) async {
    resource["resourceOwnerId"] =
        Provider.of<Auth>(context).myProfile.accountId;
    final url = "authenticated/createNewResource";
    var accessToken = Provider.of<Auth>(context).accessToken;
    try {
      final response = await ApiBaseHelper().postProtected(url,
          accessToken: accessToken, body: json.encode(resource));
      print("Success");
      await Provider.of<Auth>(context).retrieveUser();
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

  void updateResource(context) async {
    // if (coverPhoto.isNotEmpty) {
    //   await uploadSinglePic(
    //       coverPhoto.first,
    //       "${ApiBaseHelper().baseUrl}authenticated/updateProject/updateProjectProfilePic?projectId=${project['projectId']}",
    //       Provider.of<Auth>(context, listen: false).accessToken,
    //       "profilePic",
    //       context);
    // }

    var updaterId = Provider.of<Auth>(context).myProfile.accountId;
    var resourceId = resource["resourceId"];
    final url =
        "authenticated/updateResource?updaterId=${updaterId}&resourceId=${resourceId}";
    try {
      var accessToken = Provider.of<Auth>(context).accessToken;
      final response = await ApiBaseHelper().putProtected(url,
          accessToken: accessToken, body: json.encode(resource));
      Provider.of<Auth>(context).retrieveUser();
      print("Success");
      Navigator.of(context).pop(true);
      await Provider.of<Auth>(context).retrieveUser();
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
              itemCount: 7,
              itemBuilder: (context, index) {
                if (index == 0 && resource["resourceId"] == null) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Title_description(resource),
                  );
                } else if (index == 0 && resource["resourceId"] != null) {
                  return IntroItem(
                    title: titles_edit[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Title_description(resource),
                  );
                } else if (index == 1 && resource["resourceId"] == null) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Category(resource),
                  );
                } else if (index == 1 && resource["resourceId"] != null) {
                  return IntroItem(
                    title: titles_edit[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Category(resource),
                  );
                } else if (index == 2 && resource["resourceId"] == null) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Unit(resource),
                  );
                } else if (index == 2 && resource["resourceId"] != null) {
                  return IntroItem(
                    title: titles_edit[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Unit(resource),
                  );
                } else if (index == 3 && resource["resourceId"] == null) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Start(resource),
                  );
                } else if (index == 3 && resource["resourceId"] != null) {
                  return IntroItem(
                    title: titles_edit[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Start(resource),
                  );
                } else if (index == 4 && resource["resourceId"] == null) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: End(resource),
                  );
                } else if (index == 4 && resource["resourceId"] != null) {
                  return IntroItem(
                    title: titles_edit[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: End(resource),
                  );
                } else if (index == 5 && resource["resourceId"] == null) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Document(resource),
                  );
                } else if (index == 5 && resource["resourceId"] != null) {
                  return IntroItem(
                    title: titles_edit[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Document(resource),
                  );
                } else if (index == 6 && resource["resourceId"] == null) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Document(resource),
                  );
                } else if (index == 6 && resource["resourceId"] != null) {
                  return IntroItem(
                    title: titles_edit[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Document(resource),
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
                  Icon(_currentIndex == 6 ? Icons.check : Icons.arrow_forward),
              onPressed: () {
                if (_currentIndex != 6) {
                  _controller.next();
                } else if (resource["resourceId"] == null) {
                  createNewResource(context);
                } else {
                  updateResource(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class Title_description extends StatefulWidget {
  Map<String, dynamic> resource;
  // Map<int, bool> swiperControl;
  Title_description(this.resource);

  @override
  _Title_descriptionState createState() => _Title_descriptionState();
}

class _Title_descriptionState extends State<Title_description> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();
    _titleController.text = widget.resource["resourceName"];
    _descriptionController.text = widget.resource['resourceDescription'];
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
                    widget.resource["resourceName"] = text;
                  }
                  print(widget.resource["resourceName"]);
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
                  widget.resource['resourceDescription'] = text;
                  print(widget.resource['resourceDescription']);
                },
              ),
            ),
          ],
        )));
  }
}

class Category extends StatefulWidget {
  Map<String, dynamic> resource;
  Category(this.resource);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<ResourceCategory> listOfCategories;
  Future categoriesFuture;

//retrieve all categories
  retrieveAllCategories() async {
    final url = 'authenticated/getAllResourceCategories';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(this.context).accessToken);
    listOfCategories = (responseData['content'] as List)
        .map((e) => ResourceCategory.fromJson(e))
        .toList();
    print(listOfCategories[0].toJson());
  }

  Widget build(BuildContext context) {
    bool _checked = true;
    bool _unchecked = false;
    return FutureBuilder(
      future: retrieveAllCategories(),
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Scaffold(
              body: Center(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: listOfCategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return widget.resource["resourceCategoryId"] ==
                                listOfCategories[index].resourceCategoryId
                            ? CheckboxListTile(
                                title: Text(listOfCategories[index]
                                    .resourceCategoryName),
                                controlAffinity:
                                    ListTileControlAffinity.platform,
                                value: _checked,
                                onChanged: (bool value) {
                                  setState(() {
                                    _checked = value;
                                    widget.resource["resourceCategoryId"] =
                                        null;
                                    print(
                                        widget.resource["resourceCategoryId"]);
                                  });
                                })
                            : CheckboxListTile(
                                title: Text(listOfCategories[index]
                                    .resourceCategoryName),
                                controlAffinity:
                                    ListTileControlAffinity.platform,
                                value: _unchecked,
                                onChanged: (bool value) {
                                  setState(() {
                                    widget.resource["resourceCategoryId"] =
                                        listOfCategories[index]
                                            .resourceCategoryId;
                                    _unchecked = value;
                                    print(
                                        widget.resource["resourceCategoryId"]);
                                  });
                                });
                      }),
                )
              ],
            )))
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class Unit extends StatefulWidget {
  Map<String, dynamic> resource;
  Unit(this.resource);
  @override
  _UnitState createState() => _UnitState();
}

class _UnitState extends State<Unit> {
  ApiBaseHelper _helper = ApiBaseHelper();
  Future categoryFuture;
  ResourceCategory category;
  int totalUnit = 0;
  int perUnit;
  int _n = 0;
  @override
  initState() {
    categoryFuture = retrieveCategoryById();
    super.initState();
  }

  retrieveCategoryById() async {
    int id = widget.resource["resourceCategoryId"];
    final url = 'authenticated/getResourceCategoryById?resourceCategoryId=$id';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(this.context, listen: false).accessToken);
    category = ResourceCategory.fromJson(responseData);
    perUnit = category.perUnit;
    print(category.toJson());
    if (widget.resource["units"] != 0 || widget.resource["units"] != null) {
      _n = widget.resource["units"];
      totalUnit = _n * perUnit;
    }
  }

  void add() {
    setState(() {
      _n++;
      widget.resource["units"] = _n;
      totalUnit = _n * perUnit;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
      widget.resource["units"] = _n;
      totalUnit = _n * perUnit;
    });
  }

  @override
  Widget build(BuildContext context) {
    //get resource from resourceId
    if (widget.resource["resourceCategoryId"] == null) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(60, 120, 30, 0),
              child: new Text('You need to select a category first. ',
                  style: new TextStyle(fontSize: 30.0)),
            ),
          ],
        ),
      );
    } else {
      return FutureBuilder(
        future: categoryFuture,
        builder: (context, snapshot) =>
            (snapshot.connectionState == ConnectionState.done)
                ? Scaffold(
                    body: Column(
                      children: [
                        new Container(
                          padding: EdgeInsets.fromLTRB(10, 60, 10, 50),
                          child: new Center(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new FloatingActionButton(
                                  onPressed: add,
                                  child: new Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                new Text('$_n',
                                    style: new TextStyle(fontSize: 60.0)),
                                new FloatingActionButton(
                                  onPressed: minus,
                                  child: new Icon(
                                      const IconData(0xe15b,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.black),
                                  backgroundColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: new Center(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text('$totalUnit ',
                                    style: new TextStyle(fontSize: 60.0)),
                                new Text(category.unitName,
                                    style: new TextStyle(fontSize: 60.0)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                          child: Text(
                              'The unit is following our community guidelines, you can checkout the guideline details by clicking here',
                              style: new TextStyle(fontSize: 13.0)),
                        ),
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
      );
    }
  }
}

class Start extends StatefulWidget {
  Map<String, dynamic> resource;
  Start(this.resource);
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (widget.resource["startTime"] != "" &&
        widget.resource["startTime"] != null) {
      String temp = widget.resource["startTime"] + 'Z';
      dateTime = DateTime.parse(temp);
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
                widget.resource["startTime"] = formatDate(
                    DateTime(dateTime.year, dateTime.month, dateTime.day,
                        dateTime.hour, dateTime.minute, dateTime.second),
                    [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);

                print("hello");
                print(widget.resource["startTime"]);
              });
            },
          ),
        ),
      ],
    );
  }
}

class End extends StatefulWidget {
  Map<String, dynamic> resource;
  End(this.resource);
  @override
  _EndState createState() => _EndState();
}

class _EndState extends State<End> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (widget.resource["endTime"] != "" &&
        widget.resource["endTime"] != null) {
      String temp = widget.resource["endTime"] + 'Z';
      dateTime = DateTime.parse(temp);
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
                widget.resource["endTime"] = formatDate(
                    DateTime(dateTime.year, dateTime.month, dateTime.day,
                        dateTime.hour, dateTime.minute, dateTime.second),
                    [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);

                print("hello");
                print(widget.resource["endTime"]);
              });
            },
          ),
        ),
      ],
    );
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
    // final Map params = new Map();
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

/*
class FileUpload extends StatefulWidget {
  Resources resource;
  FileUpload(this.resource);
  _FileUploadState createState() => _FileUploadState(resource);
}

class _FileUploadState extends State<FileUpload> {
  Resources resource;
  _FileUploadState(this.resource);
  List<Widget> fileListThumb;
  List<File> fileList = new List<File>();

  Future pickFiles() async {
    List<Widget> thumbs = new List<Widget>();
    fileListThumb.forEach((element) {
      thumbs.add(element);
    });

    await FilePicker.getMultiFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    ).then((files) {
      if (files != null && files.length > 0) {
        files.forEach((element) {
          List<String> picExt = ['.jpg', '.jpeg', '.bmp'];

          if (picExt.contains(extension(element.path))) {
            thumbs.add(Padding(
                padding: EdgeInsets.all(1), child: new Image.file(element)));
          } else
            thumbs.add(Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Icon(Icons.insert_drive_file),
                  Text(extension(element.path))
                ])));
          fileList.add(element);
          resource.uploadedFiles.add(element.toString());
          print(resource.uploadedFiles.toList());
        });
        setState(() {
          fileListThumb = thumbs;
        });
      }
    });
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
            child: Text("Upload documents"),
          ),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => createNewResource(
      //       Provider.of<Auth>(context).accessToken, context),
      //   child: Text("Create new resource"),
      // )
    );
//     List<Map> attch = toBase64(fileList);
//     params["attachment"] = jsonEncode(attch);
//     httpSend(params).then((sukses){
//       if(sukses==true){
//           Flushbar(
//             message: "success :)",
//             icon: Icon(
//               Icons.check,
//               size: 28.0,
//               color: Colors.blue[300],
//               ),
//             duration: Duration(seconds: 3),
//             leftBarIndicatorColor: Colors.blue[300],
//           ).show(context);
//         }
//         else
//           Flushbar(
//             message: "fail :(",
//             icon: Icon(
//               Icons.error_outline,
//               size: 28.0,
//               color: Colors.blue[300],
//               ),
//             duration: Duration(seconds: 3),
//             leftBarIndicatorColor: Colors.red[300],
//           ).show(context);
//     });
//   },
//   tooltip: 'Upload File',
//   child: const Icon(Icons.cloud_upload),
// ),
  }
//   void createNewResource(accessToken, context) async {
//  if (!_formKey.currentState.validate()) {
//       // Invalid!
//       return;
//     }

//     _formKey.currentState.save();
}
*/
