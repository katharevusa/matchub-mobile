import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:matchub_mobile/model/data.dart';
import 'package:matchub_mobile/model/resource.dart';

class ResourceCreationScreen extends StatelessWidget {
  static const routeName = "/resource-title-screen";
  Resource newResource;
  ResourceCreationScreen({this.newResource});

  PageController _controller = PageController(
    initialPage: 0,
  );

  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        Title(newResource),
        Description(newResource),
        Category(newResource),
        StartDateTime(newResource),
        EndDateTime(newResource),
        // FileUpload(resource),
      ],
    );
  }
}

// class Description extends StatefulWidget {
//   _DescriptionState createState() => _DescriptionState();
// }

// class _DescriptionState extends State<Description> {
//   Widget build(BuildContext context) {
//     return Scaffold(body: Center(child: Text("Description")));
//   }
// }

class Title extends StatelessWidget {
  Resource resource;
  Title(this.resource);

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = resource.title;
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
              resource.title = text;
            },
          ),
        ),
      ],
    )));
  }
}

class Description extends StatelessWidget {
  Resource resource;
  Description(this.resource);

  @override
  Widget build(BuildContext context) {
    TextEditingController _descriptionController = new TextEditingController();
    _descriptionController.text = resource.description;
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
              resource.description = text;
            },
          ),
        ),
      ],
    )));
  }
}

class Category extends StatefulWidget {
  Resource resource;
  Category(this.resource);

  @override
  _CategoryState createState() => _CategoryState(resource);
}

class _CategoryState extends State<Category> {
  Resource resource;
  _CategoryState(this.resource);
  // List<String> _avail_categories = [
  //   "Food",
  //   "Instructor",
  //   "Transportation",
  //   "Techinicians"
  // ];

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
              return resource.resourceCategory.resourceCategoryName != null &&
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
                          print(resource.title);
                          print(resource
                              .resourceCategory.resourceCategoryDescription);
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

class StartDateTime extends StatefulWidget {
  Resource resource;
  StartDateTime(this.resource);
  _StartDateTimeState createState() => _StartDateTimeState(resource);
}

class _StartDateTimeState extends State<StartDateTime> {
  Resource resource;
  _StartDateTimeState(this.resource);
  String _date = "Not set";
  String _time = "Not set";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    print('confirm $date');
                    _date = '${date.year} - ${date.month} - ${date.day}';

                    // print(resource.startDateTime);
                    setState(() {
                      resource.startDateTime = date;
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
                    print('confirm $time');
                    _time = '${time.hour} : ${time.minute} : ${time.second}';

                    print(resource.startDateTime);
                    setState(() {
                      DateTime dt = new DateTime(
                          resource.startDateTime.year,
                          resource.startDateTime.month,
                          resource.startDateTime.day,
                          time.hour,
                          time.minute,
                          time.second);
                      resource.startDateTime = dt;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
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
                    print('confirm $date');
                    _date = '${date.year} - ${date.month} - ${date.day}';

                    // print(resource.startDateTime);
                    setState(() {
                      resource.endDateTime = date;
                      print(resource.startDateTime);
                      print(resource.endDateTime);
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
                    print('confirm $time');
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
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
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
