import 'package:flutter/material.dart';
import 'package:matchub_mobile/services/firebase.dart';

import 'channelCreation.dart';

class EditChannel extends StatelessWidget {
  Map<String, dynamic> channelMap;
  EditChannel(this.channelMap);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"), 
      ),
      body: InfoPage(channelMap: channelMap, toCreate: false,),
    );
  }
}