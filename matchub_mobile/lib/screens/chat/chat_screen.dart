import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream chatRooms;

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    await DatabaseMethods()
        .getUserChats(Provider.of<Auth>(context, listen: false).myProfile.uuid)
        .then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRooms,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Container(
              height: 80 * SizeConfig.heightMultiplier,
              child: Center(child: Text("No Chats here yet...")));
        }
        
        return ListView.builder(
              // separatorBuilder: (ctx, idx) => Divider(),
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final chatGroupSnapshot = snapshot.data.documents[index];
                final conversationRecipient =
                    (chatGroupSnapshot.data()['members'] as List).firstWhere(
                        (element) =>
                            element !=
                            Provider.of<Auth>(context, listen: false)
                                .myProfile
                                .uuid,
                        orElse: () => print('No matching element.'));
                return ChatRoomsTile(
                  uuid: conversationRecipient,
                  recentMessage: chatGroupSnapshot.data()['recentMessage']['messageText'] ?? "",
                  recentDate: (chatGroupSnapshot.data()['recentMessage']['sentAt'] is Timestamp) ? chatGroupSnapshot.data()['recentMessage']['sentAt'] : null,
                  chatRoomId: "aasdf",
                );
              }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox",
            style: TextStyle(
                color: Colors.grey[850],
                fontSize: 3 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w700)),
        elevation: 0,
        backgroundColor: kScaffoldColor,
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
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          chatRoomsList(),
        ]),
      ),
    );
  }
}

class ChatRoomsTile extends StatefulWidget {
  final String uuid;
  final String chatRoomId;
  final Timestamp recentDate;
  final String recentMessage;

  ChatRoomsTile(
      {this.uuid,
      @required this.chatRoomId,
      this.recentDate,
      this.recentMessage});

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  Profile user;
  bool isloading = true;

  @override
  initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    final response = await ApiBaseHelper().getProtected(
        "authenticated/getAccountByUUID/${widget.uuid}",
        Provider.of<Auth>(context, listen: false).accessToken);
    user = Profile.fromJson(response);
    setState(() {
      print("finished loading");
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context).myProfile;
    DateTime date;
    if (widget.recentDate != null) {
      date = widget.recentDate.toDate();
    }

    return isloading
        ? SizedBox.shrink()
        : GestureDetector(
            onTap: () async {
              String chatRoomId = await DatabaseMethods()
                  .getChatRoomId(myProfile.uuid, user.uuid);
              print(chatRoomId);
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) =>
                      Messages(chatRoomId: chatRoomId, recipient: user)));
            },
            child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: user.profilePhoto.isEmpty
                      ? AssetImage("assets/images/avatar2.jpg")
                      : NetworkImage(
                          "${ApiBaseHelper().baseUrl}${user.profilePhoto.substring(30)}"),
                ),
                title: Text(user.name),
                subtitle: Text(
                  widget.recentMessage,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: date != null
                    ? Text(
                        DateFormat('kk:mm').format(date),
                      )
                    : Text("")));
  }
}
