import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';

import 'package:matchub_mobile/models/resources.dart';

import 'package:matchub_mobile/screens/resource/resource_creation_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class OngoingResource extends StatefulWidget {
  List<Resources> listOfResources;
  OngoingResource(this.listOfResources);
  @override
  _OngoingResourceState createState() => _OngoingResourceState(listOfResources);
}

class _OngoingResourceState extends State<OngoingResource> {
  List<Resources> listOfResources;
  Future resourcesFuture;
  _OngoingResourceState(this.listOfResources);

  @override
  void initState() {
    super.initState();
    resourcesFuture = retrieveResources();
  }

  ApiBaseHelper _helper = ApiBaseHelper();
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

  retrieveResources() async {
    final url = 'authenticated/getAllResources';
    final responseData =
        await _helper.getProtected(url, Provider.of<Auth>(context).accessToken);
    listOfResources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();
    //   print(listOfResources[0].resourceName);
  }

  @override
  Widget build(BuildContext context) {
    //new empty resource

    final newResource = new Resources();

    return FutureBuilder(
      future: retrieveResources(),
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Scaffold(
              body: Column(
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
                                listOfResources[index].available == true
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
                                            true &&
                                        listOfResources[index]
                                                .matchedProjectId ==
                                            null
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FlatButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResourceCreationScreen(
                              newResource: newResource))),
                  icon: Icon(Icons.add),
                  label: Text("New")),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
