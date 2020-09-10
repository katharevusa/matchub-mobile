import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/resource.dart';
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
  // testing only
  List<Resource> _resources = [
    Resource("Resource1", "description", ["Poverty"], DateTime.now(),
        DateTime.now(), "file", "Available"),
    Resource("Resource2", "description", ["Poverty"], DateTime.now(),
        DateTime.now(), "file", "Available"),
    Resource("Resource3", "description", ["Poverty"], DateTime.now(),
        DateTime.now(), "file", "Available"),
    Resource("Resource4", "description", ["Poverty"], DateTime.now(),
        DateTime.now(), "file", "Busy"),
    Resource("Resource5", "description", ["Poverty"], DateTime.now(),
        DateTime.now(), "file", "Busy"),
    Resource("Resource6", "description", ["Poverty"], DateTime.now(),
        DateTime.now(), "file", "Busy"),
  ];
  String _selected = "All";

  //List<Resource> avail = _resources.where((element) => _resources.status == "Available").toList();

  @override
  Widget build(BuildContext context) {
    //new empty resource
    final newResource =
        new Resource(null, null, new List<String>(), null, null, null, null);
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
              itemCount: _resources.length,
              itemBuilder: (BuildContext ctx, int index) {
                return _selected == _resources[index].status
                    ? ListTile(
                        title: Text(_resources[index].title),
                      )
                    : _selected == "All"
                        ? ListTile(title: Text(_resources[index].title))
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
                      ResourceCreationScreen(resource: newResource))),
          icon: Icon(Icons.add),
          label: Text("New")),
    );
  }
}
