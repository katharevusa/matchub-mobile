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

  retrieveTaskReporterById(accountId)async {
    final response = await ApiBaseHelper.instance.getProtected(
        "authenticated/getAccount/$accountId");
    return Profile.fromJson(response);
  }

  retrieveKanbanByChannelId(channelId) async {
    final response = await ApiBaseHelper.instance.getProtected(
        "authenticated/getKanbanBoardByChannelUid?channelUId=$channelId");
    kanban = KanbanEntity.fromJson(response);
    notifyListeners();
  }

  retrieveKanbanByKanbanBoardId(kanbanBoardId) async {
    final response = await ApiBaseHelper.instance.getProtected(
        "authenticated/getKanbanBoardByKanbanBoardId?kanbanBoardId=$kanbanBoardId");
    kanban = KanbanEntity.fromJson(response);
    notifyListeners();
  }

  createTask(Map<String, dynamic> taskEntity) async {
    final response = await ApiBaseHelper.instance.postProtected(
        "authenticated/createTask",
        body: json.encode(taskEntity));
    final task = TaskEntity.fromJson(response);
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    print(task);
    notifyListeners();
  }

  reorderTaskSequence(arrangerId) async {
    var newKanbanOrder = {};
    [
      ...kanban.taskColumns.map((e) => {
            "${e.taskColumnId}": [...e.listOfTasks.map((e) => e.taskId)]
          })
    ].forEach((element) {
      newKanbanOrder.addAll(element);
    });
    print(newKanbanOrder);
    final response = await ApiBaseHelper.instance
        .putProtected("authenticated/rearrangeTasks",
            body: json.encode({
              "arrangerId": arrangerId,
              "kanbanBoardId": kanban.kanbanBoardId,
              "columnIdAndTaskIdSequence": newKanbanOrder
            }));
    kanban = KanbanEntity.fromJson(response);
    notifyListeners();
  }

  updateTaskDoers(List<Profile> newTaskDoerList, task, updaterId) async {
    String url = 
        "authenticated/updateTaskDoers?taskId=${task.taskId}&updatorId=$updaterId&kanbanBoardId=${kanban.kanbanBoardId}";
        for(var i in newTaskDoerList){
          url += "&newTaskDoerList=${i.accountId}";
        }
    final response = await ApiBaseHelper.instance.postProtected(url);
    task = TaskEntity.fromJson(response);
    print(task);
    notifyListeners();

  }
}
