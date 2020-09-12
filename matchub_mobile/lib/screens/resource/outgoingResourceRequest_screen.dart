import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/resource.dart';

class OutgoingResourceRequest extends StatefulWidget {
  @override
  _OutgoingResourceRequestState createState() =>
      _OutgoingResourceRequestState();
}

class _OutgoingResourceRequestState extends State<OutgoingResourceRequest> {
  // testing only
  List _resourceStatus = [
    "All",
    "Pending",
    "Approved",
    "Rejected",
  ];

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
