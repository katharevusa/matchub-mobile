import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/imageCapture_screen.dart';

import 'package:flutter/widgets.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class ResourceDetailScreen extends StatefulWidget {
  static const routeName = "/own-resource-detail";

  @override
  _ResourceDetailScreenState createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen>
// with TickerProviderStateMixin
{
  // double screenSize;

  // double screenRatio;

  // AppBar appBar;

  // List<Tab> tabList = List();

  // TabController _tabController;

  // @override
  // void initState() {
  //   tabList.add(new Tab(
  //     text: 'Basic Information',
  //   ));
  //   tabList.add(new Tab(
  //     text: 'Projects',
  //   ));
  //   _tabController = new TabController(vsync: this, length: tabList.length);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final Resources resource = ModalRoute.of(context).settings.arguments;
    // screenSize = MediaQuery.of(context).size.width;
    // appBar = AppBar(
    //   title: Text(resource.resourceName),
    //   elevation: 0.0,
    // );

    // return Container(
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            // onSelected: handleClick,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text("Upload image"),
                value: "0",
              ),
              PopupMenuItem(
                child: Text("Update resource"),
                value: "1",
              ),
              PopupMenuItem(
                child: Text("Terminate"),
                value: "2",
              ),
            ],
            onSelected: (result) {
              if (result == "0") {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ImageCapture(resource)),
                // );
              }
              if (result == "1") {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SettingPage()),
                // );
              }
              if (result == "2") {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SettingPage()),
                // );

              }
            },
          ),
        ],
        //  title: Text("Resources"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // bottom: PreferredSize(
        //     child: Column(
        //       children: [
        //         Gallery(resource),
        //         Container(
        //           height: 30,
        //           margin: EdgeInsets.all(11.0),
        //           child: new Text(resource.resourceName,
        //               textAlign: TextAlign.center,
        //               style: TextStyle(fontSize: 18.0)),
        //         ),
        //         TabBar(
        //             controller: _tabController,
        //             indicatorColor: Colors.pink,
        //             indicatorSize: TabBarIndicatorSize.tab,
        //             tabs: tabList),
        //       ],
        //     ),
        //     preferredSize: Size.fromHeight(300))
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ResourceHeader(resource),
            const SizedBox(height: 10.0),
            Description(resource),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}

class ResourceHeader extends StatelessWidget {
  Resources resource;
  ResourceHeader(this.resource);

  @override
  Widget build(BuildContext context) {
    Profile profile = Profile.fromJson(
        json.decode(json.encode(Provider.of<Auth>(context).myProfile)));

    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          // decoration: BoxDecoration(
          child: Column(children: <Widget>[
            Gallery(resource),
          ]),
          // ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 220),
          child: Column(
            children: <Widget>[
              Text(
                resource.resourceName,
                style: Theme.of(context).textTheme.title,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(ProfileScreen.routeName, arguments: profile);
                },
                child: Text("Listed by:"),
              )
              // if (subtitle != null) ...[
              //   const SizedBox(height: 5.0),
              //   Text(
              //     subtitle,
              //     style: Theme.of(context).textTheme.subtitle,
              //   ),
              // ]
            ],
          ),
        )
      ],
    );
  }
}

class Gallery extends StatelessWidget {
  Resources resource;
  Gallery(this.resource);
  @override
  Widget build(BuildContext context) {
    List<String> imageLinks;
    if (resource.photos.isEmpty) {
      imageLinks = ['./././assets/images/resource-default.png'];
    } else {
      imageLinks = resource.photos;
    }
  }
}

class Description extends StatefulWidget {
  Resources resource;
  Description(this.resource);
  _DescriptionState createState() => _DescriptionState(resource);
}

class _DescriptionState extends State<Description> {
  Resources resource;
  _DescriptionState(this.resource);
  ApiBaseHelper _helper = ApiBaseHelper();
  ResourceCategory category;
  Future categoryFuture;

  // Future<bool> getCategoryById(int id) async {
  //   final url = 'authenticated/getResourceCategoryById?id=$id';
  //   final responseData = await _helper.getProtected(
  //       url, Provider.of<Auth>(this.context).accessToken);
  //   category = ResourceCategory.fromJson(responseData);
  // }

  Widget build(BuildContext context) {
    String status;
    String startdatetime;
    String enddatetime;
    if (resource.available == true) {
      status = "Available";
    } else {
      status = "Unavailable";
    }
    if (resource.startTime == null) {
      startdatetime = "Not listed";
    } else {
      startdatetime = resource.startTime;
    }
    if (resource.endTime == null) {
      enddatetime = "Not listed";
    } else {
      enddatetime = resource.endTime;
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("Description"),
                  subtitle: Text(resource.resourceDescription),
                  leading: Icon(Icons.leak_add),
                ),
                ListTile(
                  title: Text("Status"),
                  subtitle: Text(status),
                  leading: Icon(Icons.event_available),
                ),
                ListTile(
                  title: Text("Start Date & Time"),
                  subtitle: Text(startdatetime),
                  leading: Icon(Icons.event_note),
                ),
                ListTile(
                  title: Text("End Date & Time"),
                  subtitle: Text(enddatetime),
                  leading: Icon(Icons.event_note),
                ),
                ListTile(
                  //      title: Text(category.resourceCategoryName),
                  //       subtitle: Text(category.resourceCategoryDescription),
                  leading: Icon(Icons.category),
                ),
                ListTile(
                  title: Text("Unit"),
                  subtitle: Text(resource.units.toString()),
                  leading: Icon(Icons.format_underlined),
                ),
              ],
            ),
          ),
          Container(child: MatchedProjects(resource)),
        ],
      ),
    );
  }
}

class MatchedProjects extends StatefulWidget {
  Resources resource;
  MatchedProjects(this.resource);
  _MatchedProjectsState createState() => _MatchedProjectsState();
}

class _MatchedProjectsState extends State<MatchedProjects> {
  //hard code layout for project screen

  final List<Map> collections = [
    {
      "title": "Setting up food stall in foriegn dorm",
      "image": './././assets/images/pancake.jpg'
    },
    {
      "title": "Photographer for food blogger",
      "image": './././assets/images/fries.jpg'
    },
    {
      "title": "Teaching program in Nepal",
      "image": './././assets/images/fishtail.jpg'
    },
    {
      "title": "Feed the birds in XYZ park",
      "image": './././assets/images/kathmandu1.jpg'
    },
  ];
  Widget build(BuildContext context) {
    if (widget.resource.matchedProjectId == null
        // && this resource belongs to the owner
        ) {
      return SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Suggested projects",
                  style: Theme.of(context).textTheme.title,
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Refresh",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 200.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: collections.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    width: 150.0,
                    height: 200.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                              collections[index]['image'],
                                            ),
                                            fit: BoxFit.cover))))),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(collections[index]['title'],
                            style: Theme.of(context)
                                .textTheme
                                .subhead
                                .merge(TextStyle(color: Colors.grey.shade600)))
                      ],
                    ));
              },
            ),
          ),
        ],
      ));
    } else {
      return SingleChildScrollView(
        child: Text("show project"),
      );
    }
  }
}
