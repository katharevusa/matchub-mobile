import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  final String chatRoomId;
  final Profile user;

  Messages({this.chatRoomId, this.user});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    loadMessages();
    Future.delayed(Duration(milliseconds: 200), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
    // Future.delayed(Duration(milliseconds: 10), () {
    //   myFocusNode.requestFocus();
    // });
    // SchedulerBinding.instance.addPostFrameCallback(
  }

  loadMessages() async {
    await DatabaseMethods().getChatMessages(widget.chatRoomId).then((val) {
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
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              print("s=============== ${index.toString()}");
              return MessageTile(
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
        "messageText": messageEditingController.text,
        'sentAt': DateTime.now()
      };
      print("reached here -1");
      print(widget.chatRoomId);
      DatabaseMethods().sendMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
        print("reached here -3");
      });
    }
  }

  deleteChat() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 60,
          titleSpacing: 10,
          // leadingWidth: 40,
          elevation: 5,
          centerTitle: false,
          title: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: widget.user.profilePhoto.isEmpty
                  ? AssetImage("assets/images/avatar2.jpg")
                  : NetworkImage(
                      "${ApiBaseHelper().baseUrl}${widget.user.profilePhoto.substring(30)}"),
            ),
            title:
                Text(widget.user.name, style: TextStyle(color: Colors.white)),
          ),
          actions: [
            PopupMenuButton(
                offset: Offset(0, 50),
                icon: Icon(
                  FlutterIcons.ellipsis_v_faw5s,
                  size: 20,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () {
                            
                          },
                          leading: Icon(FlutterIcons.trash_alt_faw5s),
                          title: Text("Delete Chat"),
                        ),
                      )
                    ]),
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
          ],
        ),
        body: Stack(children: [
          Container(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
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

class MessageTile extends StatelessWidget {
  final String message;
  final String sentBy;
  final Timestamp sentAt;
  final bool sendByMe;

  MessageTile(
      {@required this.message,
      @required this.sendByMe,
      @required this.sentBy,
      @required this.sentAt});

  @override
  Widget build(BuildContext context) {
    DateTime date = sentAt.toDate();
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 12, right: sendByMe ? 12 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(children: [
        Container(
            padding: EdgeInsets.only(top: 10, bottom: 12, left: 14, right: 40),
            decoration: BoxDecoration(
              color: sendByMe ? Color(0xFFe6f2f1) : Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(message,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))),
        Positioned(
          bottom: 4,
          right: 6,
          child: Text(DateFormat('kk:mm').format(date),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 10)),
        ),
      ]),
    );
  }
}
