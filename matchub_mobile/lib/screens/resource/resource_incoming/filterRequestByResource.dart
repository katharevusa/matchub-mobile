import 'dart:core';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/resourceRequest.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class FilterRequestByResourceScreen extends StatefulWidget {
  List<ResourceRequest> listOfRequests;
  FilterRequestByResourceScreen(this.listOfRequests);

  @override
  _FilterRequestByResourceScreenState createState() =>
      _FilterRequestByResourceScreenState();
}

class _FilterRequestByResourceScreenState
    extends State<FilterRequestByResourceScreen> {
  List<Resources> resources = [];
  List<num> resourcesId = [];
  ApiBaseHelper _helper =ApiBaseHelper.instance ;
  List<Resources> finalResources = [];
  Future resourcesFuture;

  @override
  void initState() {
    resourcesFuture = retrieveResources();
    super.initState();
  }

  retrieveResources() async {
    var profileId =
        Provider.of<Auth>(this.context, listen: false).myProfile.accountId;
    final url = 'authenticated/getHostedResources?profileId=${profileId}';
    final responseData = await _helper.getProtected(
        url,  accessToken:Provider.of<Auth>(this.context, listen: false).accessToken);
    resources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();

    for (Resources r in resources) {
      for (num n in resourcesId) {
        if (r.resourceId == n) {
          finalResources.add(r);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //get the list of resources id
    for (ResourceRequest rr in widget.listOfRequests) {
      //  retrieveResources();
      if (!resourcesId.contains(rr.resourceId)) {
        resourcesId.add(rr.resourceId);
      }
    }
    finalResources = finalResources.toSet().toList();

    return FutureBuilder(
      future: resourcesFuture,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Scaffold(
                  appBar: AppBar(
                    title: Text("Filter by resource"),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("All"),
                          onTap: () {},
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: finalResources.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return ListTile(
                                title: Text(finalResources[index].resourceName),
                                // onTap: () => selecteResource(ctx, listOfResources[index]),
                              );
                            }),
                      ],
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
