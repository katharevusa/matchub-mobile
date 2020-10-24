import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/project.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/screens/kanban/kanban.dart';
import 'package:matchub_mobile/screens/project_management/channels/channel_messages.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import 'channel_creation.dart';

class ChannelsScreen extends StatefulWidget {
  static const routeName = "/channel-screen";
  Project project;
  ChannelsScreen({this.project});

  @override
  _ChannelsScreenState createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  Stream chatRooms;

  @override
  void initState() {
    Provider.of<ManageProject>(context, listen: false).getProject(
        widget.project.projectId,);
    getProjectChannels();
    super.initState();
  }

  getProjectChannels() async {
    await DatabaseMethods()
        .getProjectChannels("${widget.project.projectId}",
            Provider.of<Auth>(context, listen: false).myProfile.uuid)
        .then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(widget.project.projectId);
      });
    });
  }

  Widget channelsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRooms,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Container(
              height: 50 * SizeConfig.heightMultiplier,
              child: Center(child: Text("No channels here yet...")));
        }

        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final channelGroupSnapshot = snapshot.data.documents[index];
              return ChannelTile(
                  channelData: channelGroupSnapshot.data(),
                  project: widget.project);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.projectTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontSize: 2.3 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600)),
        elevation: 5.0,
        centerTitle: false,
        leadingWidth: 30,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Channels",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          SizedBox(height: 5),
          channelsList(),
          // SizedBox(height: 5),
          // Text("Direct Messages",
          //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        ]),
      ),
      floatingActionButton: widget.project.projCreatorId ==
              Provider.of<Auth>(context,listen: false).myProfile.accountId
          ? FloatingActionButton(
              heroTag: "channelCreateBtn",
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            ChannelCreation(project: widget.project)));
              },
            )
          : SizedBox.shrink(),
    );
  }
}

class ChannelTile extends StatefulWidget {
  final Project project;
  final Map<String, dynamic> channelData;
  // final Timestamp recentDate;
  // final String recentMessage;

  ChannelTile({this.channelData, this.project});

  @override
  _ChannelTileState createState() => _ChannelTileState();
}

class _ChannelTileState extends State<ChannelTile> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        Navigator.of(context,)
            .push(MaterialPageRoute(
                builder: (context) => KanbanView(
                    channelData: widget.channelData, project: widget.project)))
            .then((value) {
          Provider.of<ManageProject>(context, listen: false).getProject(
              widget.project.projectId,);
        });
      },
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Row(children: [
        Icon(
          FlutterIcons.hashtag_faw5s,
          size: 16,
        ),
        SizedBox(width: 8),
        Expanded(
            child: Text(
          widget.channelData['name'],
          style: TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
        )),
      ]),
    );
  }
}
