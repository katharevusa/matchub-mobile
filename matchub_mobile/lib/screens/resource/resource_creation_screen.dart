import 'dart:collection';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/data.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ResourceCreationScreen extends StatefulWidget {
  static final String path = "/resource-creation-screen";
  Resources newResource;
  ResourceCreationScreen({this.newResource});
  @override
  _ResourceCreationScreenState createState() => _ResourceCreationScreenState();
}

class _ResourceCreationScreenState extends State<ResourceCreationScreen> {
  SwiperController _controller = SwiperController();
  int _currentIndex = 0;
  final List<String> titles = [
    "Create New Resource",
    "Create New Resource",
    "Create New Resource",
    "Create New Resource",
    "Create New Resource",
  ];
  final List<String> subtitles = [
    "Title & Description",
    "Select Category",
    "Input your unit",
    "Start Date & End Date",
    "Upload Documents",
  ];
  final List<Color> colors = [
    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.indigo.shade300,
    Colors.deepOrange.shade300,
    Colors.lime.shade300,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Title_description(widget.newResource),
                  );
                } else if (index == 1) {
                  return IntroItem(
                    title: titles[index],
                    subtitle: subtitles[index],
                    bg: colors[index],
                    widget: Category(widget.newResource),
                  );
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: FlatButton(
              child: Text("Skip"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon:
                  Icon(_currentIndex == 2 ? Icons.check : Icons.arrow_forward),
              onPressed: () {
                if (_currentIndex != 2)
                  _controller.next();
                else
                  Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}

class Title_description extends StatefulWidget {
  Resources newResource;
  Title_description(this.newResource);

  @override
  _Title_descriptionState createState() => _Title_descriptionState();
}

class _Title_descriptionState extends State<Title_description> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();
    _titleController.text = widget.newResource.resourceName;
    _descriptionController.text = widget.newResource.resourceDescription;
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
                  widget.newResource.resourceName = text;
                  print(widget.newResource.resourceName);
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
                  widget.newResource.resourceDescription = text;
                  print(widget.newResource.resourceDescription);
                },
              ),
            ),
          ],
        )));
  }
}

class Category extends StatefulWidget {
  Resources newResource;
  Category(this.newResource);
  @override
  _CategoryState createState() => _CategoryState(newResource);
}

class _CategoryState extends State<Category> {
  Resources newResource;
  _CategoryState(this.newResource);

  List<Resources> listOfCategories;
  ApiBaseHelper _helper = ApiBaseHelper();

  // Future<void> retrieveAllCategories() async {
  //   final url = 'authenticated/getAllResourceCategories';
  //   final responseData =
  //       await _helper.getProtected(url, Provider.of<Auth>(context).accessToken);
  //   listOfCategories = (responseData['content'] as List)
  //       .map((e) => Resources.fromJson(e))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    bool _checked = true;
    bool _unchecked = false;
    //retrieveAllCategories();
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: DUMMY_RESOURCE_CATEGORY.length,
            itemBuilder: (BuildContext context, int index) {
              return newResource.resourceCategory != null &&
                      newResource.resourceCategory.values.toList()[1] ==
                          DUMMY_RESOURCE_CATEGORY[index].resourceCategoryName
                  ? CheckboxListTile(
                      title: Text(
                          DUMMY_RESOURCE_CATEGORY[index].resourceCategoryName),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: _checked,
                      onChanged: (bool value) {
                        setState(() {
                          newResource.resourceCategory = null;
                          _checked = value;
                        });
                      },
                    )
                  : CheckboxListTile(
                      title: Text(
                          DUMMY_RESOURCE_CATEGORY[index].resourceCategoryName),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: _unchecked,
                      onChanged: (bool value) {
                        setState(() {
                          newResource.resourceCategory.values.toList()[1] =
                              DUMMY_RESOURCE_CATEGORY[index];
                          _unchecked = value;

                          //    print(resource.resourceCategory.resourceCategoryName);
                        });
                      },
                    );
            },
          ),
        ),
      ],
    )));
  }
}

class unit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class duration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class document extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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

/*class ResourceCreationScreen extends StatelessWidget {
  static const routeName = "/resource-title-screen";
  Resources newResource;
  ResourceCreationScreen({this.newResource});
  final GlobalKey<FormState> _formKey = GlobalKey();
  PageController _controller = PageController(
    initialPage: 0,
  );

  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        Title(newResource),
        Description(newResource),
        //    Category(newResource),
        StartDateTime(newResource),
        // EndDateTime(newResource),
        FileUpload(newResource),
        // CreateResource(newResource),
      ],
    );
  }
}

class Title extends StatelessWidget {
  Resources resource;
  Title(this.resource);

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = resource.resourceName;
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Enter Resource title:"),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            controller: _titleController,
            autofocus: true,
            onChanged: (text) {
              resource.resourceName = text;
            },
          ),
        ),
      ],
    )));
  }
}

class Description extends StatelessWidget {
  Resources resource;
  Description(this.resource);

  @override
  Widget build(BuildContext context) {
    TextEditingController _descriptionController = new TextEditingController();
    _descriptionController.text = resource.resourceDescription;
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Enter Description:"),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            controller: _descriptionController,
            autofocus: true,
            onChanged: (text) {
              resource.resourceDescription = text;
            },
          ),
        ),
      ],
    )));
  }
}

/*
class Category extends StatefulWidget {
  Resources resource;
  Category(this.resource);

  @override
  _CategoryState createState() => _CategoryState(resource);
}

class _CategoryState extends State<Category> {
  Resources resource;
  _CategoryState(this.resource);

  @override
  Widget build(BuildContext context) {
    bool _checked = true;
    bool _unchecked = false;
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Select category"),
        Expanded(
          child: ListView.builder(
            itemCount: DUMMY_RESOURCE_CATEGORY.length,
            itemBuilder: (BuildContext context, int index) {
              return resource.resourceCategory != null &&
                      resource.resourceCategory.resourceCategoryName ==
                          DUMMY_RESOURCE_CATEGORY[index].resourceCategoryName
                  ? CheckboxListTile(
                      title: Text(
                          DUMMY_RESOURCE_CATEGORY[index].resourceCategoryName),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: _checked,
                      onChanged: (bool value) {
                        setState(() {
                          resource.resourceCategory = null;
                          _checked = value;
                        });
                      },
                    )
                  : CheckboxListTile(
                      title: Text(
                          DUMMY_RESOURCE_CATEGORY[index].resourceCategoryName),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: _unchecked,
                      onChanged: (bool value) {
                        setState(() {
                          resource.resourceCategory =
                              DUMMY_RESOURCE_CATEGORY[index];
                          _unchecked = value;

                          //    print(resource.resourceCategory.resourceCategoryName);
                        });
                      },
                    );
            },
          ),
        ),
      ],
    )));
  }
}
*/
class StartDateTime extends StatefulWidget {
  Resources resource;
  StartDateTime(this.resource);
  _StartDateTimeState createState() => _StartDateTimeState(resource);
}

class _StartDateTimeState extends State<StartDateTime> {
  Resources resource;
  _StartDateTimeState(this.resource);
  String _date = "Not set";
  String _time = "Not set";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(resource.startTime);
    if (resource.startTime != null) {
      _date = '${parsedDate.year} - ${parsedDate.month} - ${parsedDate.day}';
      _time =
          '${parsedDate.hour} - ${parsedDate.minute} - ${parsedDate.second}';
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Start date time:"),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                    _date = '${date.year} - ${date.month} - ${date.day}';
                    setState(() {
                      resource.startTime = _date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    //    print('confirm $time');

                    setState(() {
                      DateTime parsedDate = DateTime.parse(resource.startTime);
                      DateTime dt = new DateTime(
                          parsedDate.year,
                          parsedDate.month,
                          parsedDate.day,
                          time.hour,
                          time.minute,
                          time.second);
                      resource.startTime =
                          '${dt.year} - ${dt.month} - ${dt.day} ${dt.hour} : ${dt.minute} : ${dt.second}';
                      // print(resource.startDateTime);
                    });
                    _time = '${time.hour} : ${time.minute} : ${time.second}';
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  // setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_time",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
class EndDateTime extends StatefulWidget {
  Resource resource;
  EndDateTime(this.resource);
  _EndDateTimeState createState() => _EndDateTimeState(resource);
}

class _EndDateTimeState extends State<EndDateTime> {
  Resource resource;
  _EndDateTimeState(this.resource);
  String _date = "Not set";
  String _time = "Not set";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (resource.endDateTime != null) {
      _date =
          '${resource.endDateTime.year} - ${resource.endDateTime.month} - ${resource.endDateTime.day}';
      _time =
          '${resource.endDateTime.hour} - ${resource.endDateTime.minute} - ${resource.endDateTime.second}';
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("End date time:"),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                    _date = '${date.year} - ${date.month} - ${date.day}';

                    // print(resource.startDateTime);
                    setState(() {
                      resource.endDateTime = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    //  print('confirm $time');

                    _time = '${time.hour} : ${time.minute} : ${time.second}';

                    setState(() {
                      DateTime dt = new DateTime(
                          resource.endDateTime.year,
                          resource.endDateTime.month,
                          resource.endDateTime.day,
                          time.hour,
                          time.minute,
                          time.second);
                      resource.endDateTime = dt;

                      print(resource.startDateTime);
                      print(resource.endDateTime);
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  // setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_time",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/
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
