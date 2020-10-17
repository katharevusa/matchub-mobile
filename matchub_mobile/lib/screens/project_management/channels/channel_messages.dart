import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/models/truncatedProfile.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:provider/provider.dart';
import 'package:string_to_hex/string_to_hex.dart';

import 'channel_settings.dart';

class ChannelMessages extends StatefulWidget {
  final Map<String, dynamic> channelData;
  final Project project;
  ChannelMessages({this.channelData, this.project});

  @override
  _ChannelMessagesState createState() => _ChannelMessagesState();
}

class _ChannelMessagesState extends State<ChannelMessages> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  List allContributors;
  FocusNode myFocusNode;
  bool isLoaded = false;
  @override
  void initState() {
    // retrieveAllContributors();
    loadMessages();
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
    // Future.delayed(Duration(milliseconds: 10), () {
    //   myFocusNode.requestFocus();
    // });
    // SchedulerBinding.instance.addPostFrameCallback(
    super.initState();
  }

  @override
  void dispose() {
    messageEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  retrieveAllContributors() async {
    final response = await ApiBaseHelper.instance.getProtected(
        "authenticated/getWholeProjectGroup?projectId=${widget.project.projectId}",
         accessToken:Provider.of<Auth>(context, listen: false).accessToken);
    print(response);
    allContributors =
        (response as List).map((e) => Profile.fromJson(e)).toList();
    print(allContributors);
    // setState(() {
    //   isLoaded = true;
    // });
  }

  loadMessages() async {
    await DatabaseMethods()
        .getChatMessages(widget.channelData['id'])
        .then((val) {
      setState(() {
        print('rached herer');
        chats = val;
      });
    });
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        print(snapshot.data.documents.length);
        // _scrollController.jumpTo(
        //   _scrollController.position.maxScrollExtent ,
        // );

        Profile myProfile = Provider.of<Auth>(context).myProfile;
        // if(!isLoaded){
        //   return Container();
        // }
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(
                project: widget.project,
                sentAt: snapshot.data.documents[index].data()["sentAt"],
                sentBy: snapshot.data.documents[index].data()["sentBy"],
                sendByMe: myProfile.uuid ==
                    snapshot.data.documents[index].data()["sentBy"],
                message: snapshot.data.documents[index].data()["messageText"],
              );
            });
      },
    );
  }

  addMessage() {
    print("reached here - 0");
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sentBy": Provider.of<Auth>(context).myProfile.uuid,
        "messageText": messageEditingController.text.trim(),
        'sentAt': DateTime.now()
      };
      print(widget.channelData['id']);
      DatabaseMethods()
          .sendMessage(widget.channelData['id'], chatMessageMap, true);

      setState(() {
        messageEditingController.text = "";
        Future.delayed(Duration(milliseconds: 200), () {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease);
        });
      });
    }
  }

  deleteChat() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 60,
          titleSpacing: 10,
          // leadingWidth: 40,
          elevation: 5,
          centerTitle: false,
          title: ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChannelSettings(
                        channelData: widget.channelData,
                        project: widget.project))),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            title: Text(
              widget.channelData['name'],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            subtitle: Text("${widget.channelData['members'].length} Members",
                style: TextStyle(
                  color: Colors.grey[300],
                )),
          ),
          actions: [
            IconButton(
              icon: Icon(FlutterIcons.info_circle_faw5s),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChannelSettings(
                          channelData: widget.channelData,
                          project: widget.project))),
            )
          ],
          // IconButton(
          //   alignment: Alignment.bottomCenter,
          //   visualDensity: VisualDensity.comfortable,
          //   icon: Icon(
          //     FlutterIcons.ellipsis_v_faw5s,
          //     size: 20,
          //     color: Colors.grey[800],
          //   ),
          //   onPressed: () => showModalBottomSheet(
          //           context: context,
          //           builder: (context) => buildMorePopUp(context))
          //       .then((value) => setState(() {
          //             loadProject = getProjects();
          //           })),
          // ),
        ),
        body: Stack(children: [
          Container(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  chatMessages(),
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                alignment: Alignment.bottomCenter,
                // height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.only(left: 24, top: 6, right: 6),
                  color: Color(0xFF828584),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        onTap: () => _scrollController.animateTo(
                            _scrollController.position.extentBefore !=
                                    _scrollController.position.maxScrollExtent
                                ? _scrollController.position.extentBefore +
                                    MediaQuery.of(context).size.height * 0.35
                                : _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease),
                        focusNode: myFocusNode,
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      InkWell(
                          onTap: () {
                            addMessage();
                          },
                          child: Container(
                            height: 50,
                            width: 30,
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Icon(
                              FlutterIcons.paper_plane_faw5s,
                              color: Colors.grey[50],
                            ),
                          )),
                    ],
                  ),
                ),
              ))
        ]));
  }
}

class MessageTile extends StatefulWidget {
  final Project project;
  final String message;
  final String sentBy;
  final Timestamp sentAt;
  final bool sendByMe;

  MessageTile(
      {@required this.project,
      @required this.message,
      @required this.sendByMe,
      @required this.sentBy,
      @required this.sentAt});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  TruncatedProfile messageSender;

  @override
  void initState() {
    print(widget.project.teamMembers);
    var allContributors = [];
    allContributors
      ..addAll(widget.project.teamMembers)
      ..addAll(widget.project.projectOwners);
    messageSender =
        allContributors.firstWhere((element) => element.uuid == widget.sentBy);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = widget.sentAt.toDate();
    print(date.toString());
    print(messageSender.toJson());
    print(widget.sendByMe);
    print(widget.message);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.sendByMe)
              CircleAvatar(
                radius: 25,
                backgroundImage: messageSender.profilePhoto.isEmpty
                    ? AssetImage("assets/images/avatar2.jpg")
                    : NetworkImage(
                        "${ApiBaseHelper.instance.baseUrl}${messageSender.profilePhoto.substring(30)}"),
              ),
            Container(
              margin: widget.sendByMe
                  ? EdgeInsets.only(left: 8 * SizeConfig.widthMultiplier)
                  : EdgeInsets.only(right: 8 * SizeConfig.widthMultiplier),
              padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: widget.sendByMe ? 0 : 2.5 * SizeConfig.widthMultiplier,
                  right:
                      widget.sendByMe ? 2.5 * SizeConfig.widthMultiplier : 0),
              width: widget.sendByMe
                  ? SizeConfig.widthMultiplier * 85
                  : SizeConfig.widthMultiplier * 75,
              alignment: widget.sendByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Stack(children: [
                Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 12, left: 14, right: 40),
                    decoration: BoxDecoration(
                      color:
                          widget.sendByMe ? Color(0xFFe6f2f1) : Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!widget.sendByMe)
                            Text(messageSender.name,
                                style: TextStyle(
                                    color: Color(StringToHex.toColor(
                                        messageSender.name.length > 7
                                            ? messageSender.name.substring(0, 7)
                                            : messageSender.name)))),
                          Text(widget.message,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'OverpassRegular',
                                  fontWeight: FontWeight.w300)),
                        ])),
                Positioned(
                  bottom: 1 * SizeConfig.widthMultiplier,
                  right: 1.5 * SizeConfig.widthMultiplier,
                  child: Text(DateFormat('kk:mm').format(date),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 10)),
                ),
              ]),
            ),
          ]),
    );
  }
}
