import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/data.dart';
import 'package:matchub_mobile/model/resource.dart';
import 'package:matchub_mobile/screens/resource/ownResourceDetail_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_creation_screen.dart';

class OngoingResource extends StatefulWidget {
  @override
  _OngoingResourceState createState() => _OngoingResourceState();
}

class _OngoingResourceState extends State<OngoingResource> {
  List _resourceStatus = [
    "All",
    "Available",
    "Busy",
  ];

  String _selected = "All";

  void selecteResource(BuildContext ctx, Resource resource) {
    Navigator.of(ctx)
        .pushNamed(OwnResourceDetailScreen.routeName, arguments: resource);
  }

  @override
  Widget build(BuildContext context) {
    //new empty resource
    final newResource = new Resource(
        title: null,
        description: null,
        startDateTime: null,
        resourceCategory: null,
        endDateTime: null,
        uploadedFiles: new List<String>(),
        available: true);
    return Scaffold(
      // body: SingleChildScrollView(
      //   child: Container(
      //     height: 400,
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
              itemCount: DUMMY_RESROUCES.length,
              itemBuilder: (BuildContext ctx, int index) {
                return _selected == "Available" &&
                        DUMMY_RESROUCES[index].available == true &&
                        DUMMY_RESROUCES[index]
                            .endDateTime
                            .isAfter(DateTime.now())
                    ? ListTile(
                        title: Text(DUMMY_RESROUCES[index].title),
                        onTap: () =>
                            selecteResource(ctx, DUMMY_RESROUCES[index]),
                      )
                    : _selected == "Busy" &&
                            DUMMY_RESROUCES[index].available == false &&
                            DUMMY_RESROUCES[index]
                                .endDateTime
                                .isAfter(DateTime.now())
                        ? ListTile(
                            title: Text(DUMMY_RESROUCES[index].title),
                            onTap: () =>
                                selecteResource(ctx, DUMMY_RESROUCES[index]),
                          )
                        : _selected == "All" &&
                                DUMMY_RESROUCES[index]
                                    .endDateTime
                                    .isAfter(DateTime.now())
                            ? ListTile(
                                title: Text(DUMMY_RESROUCES[index].title),
                                onTap: () => selecteResource(
                                    ctx, DUMMY_RESROUCES[index]),
                              )
                            : SizedBox.shrink();
              }),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FlatButton.icon(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ResourceCreationScreen(newResource: newResource))),
          icon: Icon(Icons.add),
          label: Text("New")),
    );
  }
}
