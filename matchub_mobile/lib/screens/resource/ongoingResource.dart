import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';

import 'package:matchub_mobile/models/resources.dart';

import 'package:matchub_mobile/screens/resource/resource_creation_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/resourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_resource.dart';
import 'package:provider/provider.dart';

class OngoingResource extends StatefulWidget {
  // List<Resources> listOfResources;
  // OngoingResource(this.listOfResources);
  @override
  _OngoingResourceState createState() => _OngoingResourceState();
}

class _OngoingResourceState extends State<OngoingResource> {
  List<Resources> listOfResources = [];
  // _OngoingResourceState(this.listOfResources);
  bool _isLoading;
  @override
  void initState() {
    // resourcesFuture = retrieveResources();
    _isLoading = true;
    loadResources();
    super.initState();
  }

  loadResources() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageResource>(context, listen: false)
        .getResources(profile, accessToken);
    setState(() {
      _isLoading = false;
    });
  }

  List _resourceStatus = [
    "All",
    "Available",
    "Busy",
  ];

  String _selected = "All";

  void selecteResource(BuildContext ctx, Resources individualResource) {
    Navigator.of(ctx, rootNavigator: true).pushNamed(
        ResourceDetailScreen.routeName,
        arguments: individualResource);
  }

  @override
  Widget build(BuildContext context) {
    //new empty resource
    listOfResources = Provider.of<ManageResource>(context).resources;
    final newResource = new Resources();
    return _isLoading
        ? Container(child: Center(child: Text("I am loading")))
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownButton(
                    value: _selected,
                    onChanged: (value) {
                      setState(() {
                        _selected = value;
                      });
                    },
                    items: _resourceStatus.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: listOfResources.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return _selected == "Available" &&
                                // listOfResources[index].available == true &&
                                listOfResources[index].matchedProjectId == null
                            ? ListTile(
                                title:
                                    Text(listOfResources[index].resourceName),
                                onTap: () => selecteResource(
                                    ctx, listOfResources[index]),
                              )
                            : _selected == "Busy" &&
                                    listOfResources[index].available == false &&
                                    listOfResources[index].matchedProjectId !=
                                        null
                                ? ListTile(
                                    title: Text(
                                        listOfResources[index].resourceName),
                                    onTap: () => selecteResource(
                                        ctx, listOfResources[index]),
                                  )
                                : _selected == "All" &&
                                            listOfResources[index].available ==
                                                true ||
                                        listOfResources[index].available ==
                                            false
                                    //      &&
                                    // listOfResources[index]
                                    //         .matchedProjectId ==
                                    //     null
                                    ? ListTile(
                                        title: Text(listOfResources[index]
                                            .resourceName),
                                        onTap: () => selecteResource(
                                            ctx, listOfResources[index]),
                                      )
                                    : SizedBox.shrink();
                      }),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FlatButton.icon(
                onPressed: () => Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (
                      context,
                    ) =>
                                ResourceCreationScreen(
                                    newResource: newResource))),
                icon: Icon(Icons.add),
                label: Text("New")),
          );
  }
}
