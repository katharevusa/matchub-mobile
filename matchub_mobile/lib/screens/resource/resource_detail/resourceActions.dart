import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/resourceDonate.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceRequest.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/services/manage_resource.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../style.dart';

class ResourceActions extends StatefulWidget {
  Resources resource;
  Profile profile;
  ResourceActions(this.resource, this.profile);

  @override
  _ResourceActionsState createState() => _ResourceActionsState();
}

class _ResourceActionsState extends State<ResourceActions> {
  Profile myProfile;
  List<Resources> savedResources = [];
  Future savedResourcesFuture;
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;

  @override
  void initState() {
    savedResourcesFuture = getAllSavedResources();
    super.initState();
  }

  getAllSavedResources() async {
    // final url =
    //     'authenticated/getSavedResourcesByAccountId/${widget.profile.accountId}';
    // print('reach');
    // final responseData = await _apiHelper.getProtected(url,
    //     accessToken:
    //         Provider.of<Auth>(this.context, listen: false).accessToken);
    // savedResources = (responseData['content'] as List)
    //     .map((e) => Resources.fromJson(e))
    //     .toList();
    await Provider.of<ManageResource>(this.context, listen: false)
        .getAllSavedResources(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    savedResources = Provider.of<ManageResource>(this.context).savedResources;
    return FutureBuilder(
      future: savedResourcesFuture,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: Colors.black.withOpacity(0.8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () async {
                              savedResources.indexWhere((element) =>
                                          element.resourceId ==
                                          widget.resource.resourceId) !=
                                      -1
                                  ? unsaveResource()
                                  : saveResource();

                              await Provider.of<Auth>(context, listen: false)
                                  .retrieveUser();
                              getAllSavedResources();
                              setState(() {});
                            },
                            color: AppTheme.project4,
                            textColor: Colors.white,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                savedResources.indexWhere((element) =>
                                            element.resourceId ==
                                            widget.resource.resourceId) !=
                                        -1
                                    ? Text(
                                        "Unsave",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      )
                                    : Text(
                                        "Save",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      )
                              ],
                            ),
                          ),
                          RaisedButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) => RequestFormScreen(
                                          resource: widget.resource)));
                            },
                            color: AppTheme.project4,
                            textColor: Colors.white,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "Request",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Center(child: CircularProgressIndicator()),
    );
  }

  saveResource() async {
    final url =
        "authenticated/saveResource?accountId=${widget.profile.accountId}&resourceId=${widget.resource.resourceId}";
    try {
      final response = await ApiBaseHelper.instance.postProtected(
        url,
      );
      print("Success");
      // Navigator.of(this.context).pop("Joined-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }

  unsaveResource() async {
    final url =
        "authenticated/unsaveResource?accountId=${widget.profile.accountId}&resourceId=${widget.resource.resourceId}";
    try {
      final response = await ApiBaseHelper.instance.postProtected(
        url,
      );
      print("Success");
      // Navigator.of(this.context).pop("Joined-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }
}
