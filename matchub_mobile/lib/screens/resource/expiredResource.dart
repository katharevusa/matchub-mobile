import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/data.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';

class ExpiredResource extends StatefulWidget {
  List<Resources> listOfResources;
  ExpiredResource(this.listOfResources);
  @override
  _ExpiredResourceState createState() => _ExpiredResourceState(listOfResources);
}

class _ExpiredResourceState extends State<ExpiredResource> {
  // testing only
  List<Resources> listOfResource;
  _ExpiredResourceState(this.listOfResource);
  void selecteResource(BuildContext ctx, Resources resource) {
    Navigator.of(ctx)
        .pushNamed(ResourceDetailScreen.routeName, arguments: resource);
  }

  @override
  Widget build(BuildContext context) {
    //new empty resource

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: listOfResource.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return listOfResource[index].available == false &&
                          listOfResource[index].matchedProjectId == null
                      ? ListTile(
                          title: Text(listOfResource[index].resourceName),
                          onTap: () =>
                              selecteResource(ctx, listOfResource[index]),
                        )
                      : SizedBox.shrink();
                })
          ],
        ),
      ),
    );
  }
}
