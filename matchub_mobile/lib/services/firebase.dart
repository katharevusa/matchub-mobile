import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final firestoreInstance = FirebaseFirestore.instance;

  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUnreadMessages(String chatRoomId, String userUUID) async {
    int totalUnreadMessages = 0;
    await Firestore.instance
        .collection("message")
        .doc(chatRoomId)
        .collection("messages")
        .getDocuments()
        .then((value) {
      value.docs.forEach((message) {
        if (message.get('sentBy') != userUUID && message.get('readBy').indexWhere((el) => el == userUUID) == -1) {
          totalUnreadMessages++;
        }
      });
      print("Total Unread Messages: " + totalUnreadMessages.toString());
    });
    return totalUnreadMessages;
  }

  getUserInfo(String email, String uuid) async {
    return Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: uuid)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('name', isEqualTo: searchField)
        .getDocuments();
  }

  Future<bool> addChatRoom(chatRoom, [chatRoomId]) {
    Firestore.instance
        .collection("groups")
        .add(chatRoom)
        .then((value) => Firestore.instance
            .collection("groups")
            .doc(value.id)
            .set({"id": value.id}, SetOptions(merge: true)))
        .catchError((e) {
      print(e);
    });
  }

  checkChatRoomExists(fromUUID, toUUID) async {
    print([fromUUID, toUUID]);

    final result = await Firestore.instance
        .collection("groups")
        .where('members', whereIn: [
      [fromUUID, toUUID]..sort()
    ]).getDocuments();
    print(result.size > 0);
    return result.size > 0;
  }

  checkUserIsAdmn(adminUUID, projectId) async {
    final result = await Firestore.instance
        .collection("channels")
        .where('projectId', isEqualTo: projectId)
        .where(
          "admins",
          arrayContains: adminUUID,
        ) //need check owner also
        .get()
        .then((value) => null);
    return result.size > 0;
  }

  removeFromChannels(memberUUID, projectId) async {
    print("reached here");
    final result = await Firestore.instance
        .collection("channels")
        .where('projectId', isEqualTo: projectId)
        .where('members', arrayContains: memberUUID)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach((element) {
            element.data().update(
                "members", (value) => FieldValue.arrayRemove(memberUUID));
          }),
        );
  }

  getChatMessages(String chatRoomId) async {
    return Firestore.instance
        .collection("message")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('sentAt')
        .snapshots();
  }

  getChatRoomId(fromUUID, toUUID) async {
    final result = await Firestore.instance
        .collection("groups")
        .where('members', whereIn: [
      [fromUUID, toUUID]..sort()
    ]).getDocuments();
    return result.docs.first.id;
  }

  Future<void> sendMessage(String chatRoomId, chatMessageData, bool isChannel) {
    firestoreInstance
        .collection("message")
        .doc(chatRoomId)
        .collection("messages")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
      print("reached here -2");
    });

    if (isChannel) {
      firestoreInstance
          .collection("channels")
          .doc(chatRoomId)
          .set({"recentMessage": chatMessageData}, SetOptions(merge: true));
    } else {
      firestoreInstance
          .collection("groups")
          .doc(chatRoomId)
          .set({"recentMessage": chatMessageData}, SetOptions(merge: true));
    }
  }

  getUserChats(String userUUID) async {
    return firestoreInstance
        .collection("groups")
        .where('members', arrayContains: userUUID)
        .snapshots();
  }

  getProjectChannels(projectId, userUUID) async {
    print("fdsafsdfa");
    return firestoreInstance
        .collection("channels")
        .where('projectId', isEqualTo: projectId)
        .where('members', arrayContains: userUUID)
        .snapshots();
  }

  Future<String> createChannel(Map<String, dynamic> channelMap) async {
    String channelId;
    await firestoreInstance
        .collection("channels")
        .add(channelMap)
        .then((value){firestoreInstance
            .collection("channels")
            .doc(value.id)
            .set({"id": value.id}, SetOptions(merge: true));
            channelId = value.id;
            })
        .catchError((e) {
      print(e);
    });
    return channelId;
  }

  updateChannel(Map<String, dynamic> channelMap) async {
    firestoreInstance
        .collection("channels")
        .doc(channelMap["id"])
        .set(channelMap, SetOptions(merge: true))
        .catchError((e) {
      print(e);
    });
  }

  deleteChannel(String channelId) async {
    firestoreInstance
        .collection("channels")
        .doc(channelId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  deleteChat(String chatId) async {
    firestoreInstance.collection("groups").doc(chatId).delete().catchError((e) {
      print(e);
    });
  }
}
