import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/models/index.dart';

import '../../../style.dart';

class PPublicAnnouncements extends StatelessWidget {
  List<Announcement> publicAnnouncements;
  PPublicAnnouncements({this.publicAnnouncements});
  @override
  Widget build(BuildContext context) {
    print("reach");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kScaffoldColor,
          elevation: 0,
          title: Text("View announcement history",
              style: TextStyle(color: Colors.black)),
          // automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            itemCount: publicAnnouncements.length,
            itemBuilder: (
              context,
              index,
            ) {
              return InkWell(
                child: ListTile(
                  leading: Column(children: [
                    Text(
                      DateFormat('E')
                          .format(publicAnnouncements[index].timestamp),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    Text(
                      publicAnnouncements[index].timestamp.day.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      DateFormat('MMM')
                          .format(publicAnnouncements[index].timestamp),
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    )
                  ]),
                  title: Text(
                    publicAnnouncements[index].title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                  ),
                  subtitle: Text(publicAnnouncements[index].content),
                ),
              );
            }));
  }
}
