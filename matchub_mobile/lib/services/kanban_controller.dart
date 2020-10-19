import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class KanbanController with ChangeNotifier {
  KanbanEntity kanban;
  List<Profile> channelMembers = [];

  retrieveChannelMembers(membersList) async {
    channelMembers.clear();
    for (String s in membersList) {
      final response = await ApiBaseHelper.instance
          .getProtected("authenticated/getAccountByUUID/$s");
      channelMembers.add(Profile.fromJson(response));
    }
  }

  retrieveKanbanByChannelId(channelId) async {
    final response = await ApiBaseHelper.instance.getProtected(
        "authenticated/getKanbanBoardByChannelUid?channelUId=$channelId");
    kanban = KanbanEntity.fromJson(response);
    notifyListeners();
  }

  createTask(Map<String, dynamic> taskEntity) async {
    final response = await ApiBaseHelper.instance.postProtected(
        "authenticated/createTask",
        body: json.encode(taskEntity));
    final task = TaskEntity.fromJson(response);
    await retrieveKanbanByChannelId(kanban.kanbanBoardId);
    print(task);
    notifyListeners();
  }
}
