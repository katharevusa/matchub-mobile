import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/resource/resource_creation_screen.dart';

import 'package:flutter/widgets.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceRequest.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/connectedProject.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/resourceActions.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/resourceGallery.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/resourceInformation.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/resourceSuggestProject.dart';
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
          resource.resourceOwnerId ==
                  Provider.of<Auth>(context, listen: false).myProfile.accountId
              ? IconButton(
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
                )
              : Container(),
        ],
        backgroundColor: AppTheme.appBackgroundColor,
        elevation: 0,
      ),
      body: Stack(children: [
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(children: <Widget>[
                    RGallery(resource),
                    ResourceInformation(resource),
                  ]),
                  // ),
                ),
                resource.matchedProjectId == null
                    ? MatchedProjects(resource)
                    : ConnectedProject(resource),
              ],
            ),
          ),
        ),
        resource.resourceOwnerId ==
                Provider.of<Auth>(context, listen: false).myProfile.accountId
            ? Container()
            : ResourceActions(resource, Provider.of<Auth>(context).myProfile),
      ]),
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
