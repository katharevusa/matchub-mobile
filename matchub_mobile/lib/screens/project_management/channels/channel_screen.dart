import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/project.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/screens/project_management/channels/chat_drawer.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/database.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import 'channel_creation.dart';

class ChannelsScreen extends StatefulWidget {
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
        .getProjectChannels("${widget.project.projectId}")
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
          return Container(child: Text("asdfasdfsdfaf"));
        }

        return Expanded(
          child: ListView.builder(
              // separatorBuilder: (ctx, idx) => Divider(),
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final channelGroupSnapshot = snapshot.data.documents[index];

                print("123123123");
                print(snapshot.data.documents.length);
                return ChannelTile(
                  name: channelGroupSnapshot.data()['name'],
                  // recentMessage: channelGroupSnapshot.data()['recentMessage'] !=
                  //         null
                  //     ? channelGroupSnapshot.data()['recentMessage']['messageText']
                  //     : "",
                  // recentDate: channelGroupSnapshot.data()['recentMessage'] != null
                  //     ? channelGroupSnapshot.data()['recentMessage']['sentAt']
                  //     : null,
                  // chatRoomId: "aasdf",
                );
              }),
        );
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
                fontSize: 2.5 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600)),
        elevation: 5.0,
        // backgroundColor: kScaffoldColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
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
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChannelCreation(project: widget.project)));
        },
      ),
    );
  }
}

class ChannelTile extends StatefulWidget {
  final String name;
  // final String chatRoomId;
  final Timestamp recentDate;
  final String recentMessage;

  ChannelTile(
      {this.name,
      // @required this.chatRoomId,
      this.recentDate,
      this.recentMessage});

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
          // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          //     builder: (context) =>
          //         Messages(chatRoomId: chatRoomId, user: user)));
        },
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Row(children: [
            Icon(
              FlutterIcons.hashtag_faw5s,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(widget.name, style: TextStyle(fontSize: 18)),
          ]),
        ));
  }
}
