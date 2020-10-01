import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/project.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/screens/project_management/channels/channel_messages.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/database.dart';
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
        if (!snapshot.hasData) {
          return Container(child: Text(""));
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
        // backgroundColor: kScaffoldColor,
        centerTitle: false,
        leadingWidth: 30,
        // bottom: PreferredSize(
        //   preferredSize: Size(SizeConfig.widthMultiplier * 100, 60),
        //   child: Container(
        //     margin: EdgeInsets.all(5),
        //     padding: EdgeInsets.all(16),
        //     decoration: BoxDecoration(
        //         color: Colors.white.withOpacity(0.3),
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(50),
        //         )),
        //     child:TextField(
        //         decoration: InputDecoration(
        //           border: InputBorder.none,
        //           prefixIcon: Icon(
        //             FlutterIcons.search_fea,
        //             color: Colors.black54,
        //           ),
        //           hintText: "Search",
        //           hintStyle: TextStyle(
        //             color: Colors.black54,
        //           ),
        //         ),

        //     ),
        //   ),
        // ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       AuthService().signOut();
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (context) => Authenticate()));
        //     },
        //     child: Container(
        //         padding: EdgeInsets.symmetric(horizontal: 16),
        //         child: Icon(Icons.exit_to_app)),
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Channels",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          SizedBox(height: 5),
          channelsList(),
          SizedBox(height: 5),
          Text("Direct Messages",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        ]),
      ),
      floatingActionButton: widget.project.projCreatorId ==
              Provider.of<Auth>(context).myProfile.accountId
          ? FloatingActionButton(
              heroTag: "channelCreateBtn",
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(
                    context, rootNavigator: true).push(
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
    return GestureDetector(
        onTap: () async {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => ChannelMessages(
                  channelData: widget.channelData, project: widget.project)));
        },
        child: ListTile(
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
        ));
  }
}
