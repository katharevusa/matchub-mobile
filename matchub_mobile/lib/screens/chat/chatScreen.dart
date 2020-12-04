import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
        print("reached chatroomlist");

        return ListView.builder(
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
                recentMessage: chatGroupSnapshot.data()['recentMessage']
                        ['messageText'] ??
                    "",
                recentDate: (chatGroupSnapshot.data()['recentMessage']['sentAt']
                        is Timestamp)
                    ? chatGroupSnapshot.data()['recentMessage']['sentAt']
                    : null,
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Inbox",
      //       style: TextStyle(
      //           color: Colors.grey[850],
      //           fontSize: 3 * SizeConfig.textMultiplier,
      //           fontWeight: FontWeight.w700)),
      //   elevation: 0,
      //   backgroundColor: kScaffoldColor,
      //   centerTitle: false,
      //   automaticallyImplyLeading: false,
      //   // bottom: PreferredSize(
      //   //   preferredSize: Size(SizeConfig.widthMultiplier * 100, 60),
      //   //   child: Container(
      //   //     margin: EdgeInsets.all(5),
      //   //     padding: EdgeInsets.all(16),
      //   //     decoration: BoxDecoration(
      //   //         color: Colors.white.withOpacity(0.3),
      //   //         borderRadius: BorderRadius.all(
      //   //           Radius.circular(50),
      //   //         )),
      //   //     child:TextField(
      //   //         decoration: InputDecoration(
      //   //           border: InputBorder.none,
      //   //           prefixIcon: Icon(
      //   //             FlutterIcons.search_fea,
      //   //             color: Colors.black54,
      //   //           ),
      //   //           hintText: "Search",
      //   //           hintStyle: TextStyle(
      //   //             color: Colors.black54,
      //   //           ),
      //   //         ),

      //   //     ),
      //   //   ),
      //   // ),
      // ),
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
  final Timestamp recentDate;
  final String recentMessage;

  ChatRoomsTile({this.uuid, this.recentDate, this.recentMessage});

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  Profile user;
  bool isloading;
  int unreadMessages = 0;
  String chatRoomId;

  @override
  initState() {
    isloading = true;
    getUserDetails();
    print("chat room til");
    super.initState();
  }

  @override
  void didUpdateWidget(ChatRoomsTile oldWidget) {
    getNoOfUnread();
    super.didUpdateWidget(oldWidget);
  }

  getUserDetails() async {
    final response = await ApiBaseHelper.instance
        .getProtected("authenticated/getAccountByUUID/${widget.uuid}");
    user = Profile.fromJson(response);
    getNoOfUnread();
  }

  getNoOfUnread() async {
    // isloading = true;
    Profile myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    if (chatRoomId == null) {
      chatRoomId =
          await DatabaseMethods().getChatRoomId(myProfile.uuid, user.uuid);
    }
    print(chatRoomId);
    unreadMessages =
        await DatabaseMethods().getUnreadMessages(chatRoomId, myProfile.uuid);
    setState(() {
      print("ChatList Screen Finished Loading");
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime date;
    if (widget.recentDate != null) {
      date = widget.recentDate.toDate();
    }

    return isloading
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[300],
              child: ChatListLoader(),
              period: Duration(milliseconds: 800),
            ),
          )
        : GestureDetector(
            onTap: () async {
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          Messages(chatRoomId: chatRoomId, recipient: user)))
                  .then((value) => getNoOfUnread());
            },
            child: Badge(
              showBadge: unreadMessages != 0,
              badgeContent: Text(unreadMessages.toString(),style: TextStyle(color: Colors.white),),
              position: BadgePosition.bottomEnd(
                  bottom: SizeConfig.heightMultiplier * 2,
                  end: SizeConfig.widthMultiplier * 4),
              shape: BadgeShape.circle,
              borderRadius: BorderRadius.circular(20),
              badgeColor: kSecondaryColor,
              child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: user.profilePhoto.isEmpty
                        ? AssetImage("assets/images/avatar2.jpg")
                        : NetworkImage(
                            "${ApiBaseHelper.instance.baseUrl}${user.profilePhoto.substring(30)}"),
                  ),
                  title: Text(user.name),
                  subtitle: Text(
                    widget.recentMessage,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: date != null
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.heightMultiplier * 3),
                          child: Text(
                            DateFormat('kk:mm').format(date),
                          ),
                        )
                      : Text("")),
            ));
  }
}

class ChatListLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 200;
    double containerHeight = 15;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Container(
              height: 50,
              width: 50,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth - 50,
                color: Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }
}
