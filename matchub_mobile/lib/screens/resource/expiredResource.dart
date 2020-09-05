import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/screens/resource/model/resource.dart';
import 'package:matchub_mobile/screens/resource/newResouce/title_screen.dart';
import 'package:matchub_mobile/screens/resource/model/resource.dart';

class ExpiredResource extends StatefulWidget {
  @override
  _ExpiredResourceState createState() => _ExpiredResourceState();
}

class _ExpiredResourceState extends State<ExpiredResource> {
  // testing only
  List _resources = [
    Resource("Resource7", "description", ["Poverty"], "Expired"),
    Resource("Resource8", "description", ["Poverty"], "Expired"),
    Resource("Resource9", "description", ["Poverty"], "Expired"),
  ];

  @override
  Widget build(BuildContext context) {
    //new empty resource

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (var item in _resources)
              ListTile(
                  title: Text(item.title),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => null));
                  })
          ],
        ),
      ),
    );
  }
}
