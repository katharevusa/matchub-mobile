import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/database.dart';
import 'package:matchub_mobile/style.dart';

import 'channel_creation.dart';

class EditChannelMembers extends StatelessWidget {
  Map<String, dynamic> channelMap;
  Project project;
  List<TruncatedProfile> contributors;
  List<TruncatedProfile> filteredContributors;

  EditChannelMembers(this.channelMap, this.project);
  @override
  Widget build(BuildContext context) {
    contributors = [];
    contributors..addAll(project.teamMembers);
    filteredContributors = contributors;
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Channel Members"),
        ),
        body: Column(children: [
          SelectMembers(
            channelMap: channelMap,
            contributors: contributors,
            filteredContributors: filteredContributors,
          ),
          RaisedButton(
              color: kAccentColor,
              onPressed: () {
                // print(channelMap);
                DatabaseMethods().updateChannel(channelMap);
                Navigator.pop(context, true);
              },
              child: Text("Submit"))
        ]));
  }
}
