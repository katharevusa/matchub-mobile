import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';

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
        body: SelectMembers(
          channelMap: channelMap,
          contributors: contributors,
          filteredContributors: filteredContributors,
        ));
  }
}
