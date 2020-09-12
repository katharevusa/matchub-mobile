import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/model/data.dart';
import 'package:matchub_mobile/model/resource.dart';
import 'package:matchub_mobile/screens/resource/ownResourceDetail_screen.dart';

class ExpiredResource extends StatefulWidget {
  @override
  _ExpiredResourceState createState() => _ExpiredResourceState();
}

class _ExpiredResourceState extends State<ExpiredResource> {
  // testing only

  void selecteResource(BuildContext ctx, Resource resource) {
    Navigator.of(ctx)
        .pushNamed(OwnResourceDetailScreen.routeName, arguments: resource);
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
                itemCount: DUMMY_RESROUCES.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return DUMMY_RESROUCES[index]
                          .endDateTime
                          .isBefore(DateTime.now())
                      ? ListTile(
                          title: Text(DUMMY_RESROUCES[index].title),
                          onTap: () =>
                              selecteResource(ctx, DUMMY_RESROUCES[index]),
                        )
                      : SizedBox.shrink();
                })
          ],
        ),
      ),
    );
  }
}
