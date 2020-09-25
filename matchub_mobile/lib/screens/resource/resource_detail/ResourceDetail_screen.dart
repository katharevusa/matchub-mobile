import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_creation_screen.dart';

import 'package:flutter/widgets.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceRequest.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class ResourceDetailScreen extends StatefulWidget {
  static const routeName = "/own-resource-detail";

  @override
  _ResourceDetailScreenState createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  Resources resource;

  @override
  Widget build(BuildContext context) {
    resource = ModalRoute.of(context).settings.arguments;
    // Provider.of<Auth>(context).retrieveUser();
    return Scaffold(
      backgroundColor: AppTheme.appBackgroundColor,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: IconButton(
            color: Colors.grey[850],
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          IconButton(
            alignment: Alignment.bottomCenter,
            visualDensity: VisualDensity.comfortable,
            icon: Icon(
              FlutterIcons.ellipsis_v_faw5s,
              size: 20,
              color: Colors.grey[800],
            ),
            onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => buildMorePopUp(context)),
          ),
        ],
        backgroundColor: AppTheme.appBackgroundColor,
        elevation: 0,
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

  Container buildMorePopUp(BuildContext context) {
    return Container(
        height: 300,
        child: Column(
          children: [
            if (resource.resourceOwnerId ==
                Provider.of<Auth>(context).myProfile.accountId) ...[
              FlatButton(
                  onPressed: () => Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => ResourceCreationScreen(
                                  newResource: resource)))
                          .then((value) {
                        setState(() {
                          Provider.of<Auth>(context).retrieveUser();
                          // build(context);
                        });
                      }),
                  visualDensity: VisualDensity.comfortable,
                  highlightColor: Colors.transparent,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          FlutterIcons.edit_2_fea,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Edit Resource", style: AppTheme.titleLight),
                    ],
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _terminateDialog(context);
                  },
                  visualDensity: VisualDensity.comfortable,
                  highlightColor: Colors.transparent,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          FlutterIcons.stop_circle_faw,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Terminate", style: AppTheme.titleLight),
                    ],
                  )),
            ],
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.save_ant,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Save", style: AppTheme.titleLight),
                  ],
                )),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => RequestFormScreen(resource)));
                },
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.application_export_mco,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Request", style: AppTheme.titleLight),
                  ],
                )),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.share_2_fea,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Share", style: AppTheme.titleLight),
                  ],
                )),
          ],
        ));
  }

  _terminateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(right: 16.0),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75),
                      bottomLeft: Radius.circular(75),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                      image: AssetImage(
                        './././assets/images/info-icon.png',
                      ),
                    ))),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Alert!",
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(height: 10.0),
                        Flexible(
                          child: Text("Do you want to terminate the resource?"),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                child: Text("No"),
                                color: Colors.red,
                                colorBrightness: Brightness.dark,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: RaisedButton(
                                child: Text("Yes"),
                                color: Colors.green,
                                colorBrightness: Brightness.dark,
                                onPressed: () {
                                  terminateResource();
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void terminateResource() async {
    var profileId = Provider.of<Auth>(context).myProfile.accountId;
    final url =
        "authenticated/terminateResource?resourceId=${resource.resourceId}&terminatorId=${profileId}";
    try {
      var accessToken = Provider.of<Auth>(context).accessToken;
      final response =
          await ApiBaseHelper().postProtected(url, accessToken: accessToken);
      print("Success");
      Provider.of<Auth>(context).retrieveUser();
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
}

class ResourceHeader extends StatefulWidget {
  Resources resource;
  ResourceHeader(this.resource);

  @override
  _ResourceHeaderState createState() => _ResourceHeaderState();
}

class _ResourceHeaderState extends State<ResourceHeader> {
  Profile resourceOwner;

  Future resourceOwnerFuture;

  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  void initState() {
    super.initState();
    resourceOwnerFuture = getResourceOwner();
  }

  getResourceOwner() async {
    final url = 'authenticated/getAccount/${widget.resource.resourceOwnerId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    resourceOwner = Profile.fromJson(responseData);
  }

  @override
  Widget build(BuildContext context) {
    Profile profile = Provider.of<Auth>(context).myProfile;
    return FutureBuilder(
      future: resourceOwnerFuture,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Column(children: <Widget>[
                        Gallery(widget.resource),
                      ]),
                      // ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.resource.resourceName,
                            style: Theme.of(context).textTheme.title,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(ProfileScreen.routeName,
                                  arguments: widget.resource.resourceOwnerId);
                            },
                            child: Text(
                              "Listed by: " + resourceOwner.name,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Center(child: CircularProgressIndicator()),
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
      imageLinks = [
        'https://localhost:8443/api/v1/files/init/resource_default.jpg'
      ];
    } else {
      imageLinks = resource.photos.cast<String>().toList();
    }
    print(imageLinks);
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: false,
        autoPlay: false,
        aspectRatio: 1.8,
        viewportFraction: 1.0,
        enlargeCenterPage: true,
      ),
      items: imageLinks
          .map((item) => Container(
                decoration: BoxDecoration(boxShadow: [
                  // BoxShadow(
                  //   offset: Offset(4, 10),
                  //   blurRadius: 10,
                  //   color: Colors.grey[300].withOpacity(0.2),
                  // ),
                  // BoxShadow(
                  //   offset: Offset(-4, 10),
                  //   blurRadius: 30,
                  //   color: Colors.grey[300].withOpacity(0.2),
                  // ),
                ]),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 6,
                    vertical: SizeConfig.heightMultiplier * 2),
                child: Material(
                  elevation: 1 * SizeConfig.heightMultiplier,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: Stack(
                        children: <Widget>[
                          AttachmentImage(item),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                // 'No. ${imgList.indexOf(item)} image',
                                '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ))
          .toList(),
    );
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

  // @override
  // void initState() {
  //   super.initState();
  //   categoryFuture = getCategoryById(resource.resourceCategoryId);
  // }

  getCategoryById(int id) async {
    final url = 'authenticated/getResourceCategoryById?resourceCategoryId=$id';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(this.context).accessToken);
    category = ResourceCategory.fromJson(responseData);
  }

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

    return FutureBuilder(
      future: getCategoryById(resource.resourceCategoryId),
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? SingleChildScrollView(
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
                          title: Text(category.resourceCategoryName),
                          subtitle: Text(category.resourceCategoryDescription),
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
            )
          : Center(child: CircularProgressIndicator()),
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
