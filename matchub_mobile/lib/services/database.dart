import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
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

  Future<void> sendMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("message")
        .doc(chatRoomId)
        .collection("messages")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
      print("reached here -2");
    });
    FirebaseFirestore.instance
        .collection("groups")
        .doc(chatRoomId)
        .set({"recentMessage": chatMessageData}, SetOptions(merge: true));
  }

  getUserChats(String userUUID) async {
    return Firestore.instance
        .collection("groups")
        .where('members', arrayContains: userUUID)
        .snapshots();
  }

  getProjectChannels(projectId) async {
    print("fdsafsdfa");
    return Firestore.instance
        .collection("channels")
        .where('projectId', isEqualTo: projectId)
        .snapshots();
  }

  createChannel(Map<String, dynamic> channelMap) async {
    Firestore.instance
        .collection("channels")
        .add(channelMap)
        .then((value) => Firestore.instance
            .collection("channels")
            .doc(value.id)
            .set({"id": value.id}, SetOptions(merge: true)))
        .catchError((e) {
      print(e);
    });
  }
}
