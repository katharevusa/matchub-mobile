import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class KanbanController with ChangeNotifier {
  KanbanEntity kanban;
  List<Profile> channelMembers = [];
  List<Profile> channelAdmins = [];
  Map<String, dynamic> labels = {
    "Design": "#d11141",
    "Mapping": "#00b159",
    "Urgent": "#00aedb",
  };

  retrieveLabelsByKanbanBoard() async {
    final response = await ApiBaseHelper.instance.getWODecode(
        "authenticated/getAllLabelsByKanbanBoardId?kanbanBoardId=${kanban.kanbanBoardId}");
    print(labels);
    labels = response as Map<String, dynamic>;
  }

  retrieveChannelMembers(membersList) async {
    channelMembers.clear();
    for (String memberUUID in membersList) {
      final response = await ApiBaseHelper.instance
          .getProtected("authenticated/getAccountByUUID/$memberUUID");
      channelMembers.add(Profile.fromJson(response));
    }
  }

  retrieveChannelAdmins(adminsList) async {
    channelAdmins.clear();
    for (String memberUUID in adminsList) {
      final response = await ApiBaseHelper.instance
          .getProtected("authenticated/getAccountByUUID/$memberUUID");
      channelAdmins.add(Profile.fromJson(response));
    }
  }

  retrieveTaskReporterById(accountId) async {
    final response = await ApiBaseHelper.instance
        .getProtected("authenticated/getAccount/$accountId");
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
    for (var i in newTaskDoerList) {
      url += "&newTaskDoerList=${i.accountId}";
    }
    final response = await ApiBaseHelper.instance.postProtected(url);
    task = TaskEntity.fromJson(response);
    print(task);
    notifyListeners();
  }

  updateTaskColumn(TaskColumnEntity currentColumn, TaskColumnEntity newColumn,
      TaskEntity task) {
    currentColumn.listOfTasks.remove(task);
    newColumn.listOfTasks.add(task);
    task.taskColumn = newColumn;
    notifyListeners();
  }
}

