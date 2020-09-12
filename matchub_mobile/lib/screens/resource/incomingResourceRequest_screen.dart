import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/resource.dart';

class IncomingResourceRequest extends StatefulWidget {
  @override
  _IncomingResourceRequestState createState() =>
      _IncomingResourceRequestState();
}

class _IncomingResourceRequestState extends State<IncomingResourceRequest> {
  List _resourceStatus = [
    "All",
    "Pending",
    "Approved",
    "Rejected",
  ];
  // List _resources = [
  //   Resource("Resource7", "description", ["Poverty"], DateTime.now(),
  //       DateTime.now(), "file", "Available"),
  //   Resource("Resource8", "description", ["Poverty"], DateTime.now(),
  //       DateTime.now(), "file", "Available"),
  //   Resource("Resource9", "description", ["Poverty"], DateTime.now(),
  //       DateTime.now(), "file", "Available"),
  // ];
  String _selected = "All";
  @override
  Widget build(BuildContext context) {
    //new empty resource
    return Scaffold(
      // body: SingleChildScrollView(
      //   child: Container(
      //     height: 400,
      body: Column(
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
          // ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: _resources.length,
          //     itemBuilder: (BuildContext ctx, int index) {
          //       return _selected == _resources[index].status
          //           ? ListTile(
          //               title: Text(_resources[index].title),
          //             )
          //           : _selected == "All"
          //               ? ListTile(title: Text(_resources[index].title))
          //               : SizedBox.shrink();
          //     }),
        ],
      ),
    );
  }
}
