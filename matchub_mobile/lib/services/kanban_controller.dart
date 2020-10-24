import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class KanbanController with ChangeNotifier {
  KanbanEntity kanban;
  List<Profile> channelMembers = [];
  List<Profile> channelAdmins = [];
  Map<String, dynamic> labels = {};
  // {
  //   "Design": "#d11141",
  //   "Mapping": "#00b159",
  //   "Urgent": "#00aedb",
  // };

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
    await retrieveLabelsByKanbanBoard();
    notifyListeners();
  }

  // ===================================================================================
  // Task Methods

  createTask(Map<String, dynamic> taskEntity) async {
    final response = await ApiBaseHelper.instance.postProtected(
        "authenticated/createTask",
        body: json.encode(taskEntity));
    final task = TaskEntity.fromJson(response);
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    print(task);
    notifyListeners();
  }

  updateTask(TaskEntity task) async {
    final response =
        await ApiBaseHelper.instance.postProtected("authenticated/updateTask",
            body: json.encode({
              "taskId": task.taskId,
              "taskTitle": task.taskTitle,
              "taskDescription": task.taskDescription,
              "expectedDeadline": task.expectedDeadline.toIso8601String(),
              "taskLeaderId": task.taskLeaderId,
              "taskCreatorOrEditorId": task.taskCreatorId,
              "kanbanboardId": kanban.kanbanBoardId
            }));
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    print(task);
    notifyListeners();
  }

  updateTaskDoers(List<Profile> newTaskDoerList, task, updaterId) async {
    String url =
        "authenticated/updateTaskDoers?taskId=${task.taskId}&updatorId=$updaterId&kanbanBoardId=${kanban.kanbanBoardId}";
    for (var i in newTaskDoerList) {
      url += "&newTaskDoerList=${i.accountId}";
    }
    if (newTaskDoerList.isEmpty) {
      url += "&newTaskDoerList=";
    }
    final response = await ApiBaseHelper.instance.postProtected(url);
    task = TaskEntity.fromJson(response);
    notifyListeners();
  }

  updateTaskLabels(TaskEntity task) async {
    String url = "authenticated/updateLabel";
    final response = await ApiBaseHelper.instance.putProtected(url,
        body: json.encode(
            {"labelAndColour": task.labelAndColour, "taskId": task.taskId}));
    task = TaskEntity.fromJson(response);
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    notifyListeners();
  }

  deleteDocuments(List<String> docsToDelete, task) async {
    String url = "authenticated/deleteDocuments?taskId=${task.taskId}";
    for (var i in docsToDelete) {
      url += "&docsToDelete=$i";
    }

    final response = await ApiBaseHelper.instance.putProtected(url);
    task = TaskEntity.fromJson(response);
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    notifyListeners();
  }

  deleteTask(TaskEntity task) async {
    String url = "authenticated/deleteTask?taskId=";
    final response = await ApiBaseHelper.instance.putProtected(url,
        body: json.encode(
            {"labelAndColour": task.labelAndColour, "taskId": task.taskId}));
    task = TaskEntity.fromJson(response);
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    notifyListeners();
  }

  addComment(TaskEntity task, String content, int creatorId) async {
    final response = await ApiBaseHelper.instance
        .postProtected("authenticated/addCommentToTask?taskId=${task.taskId}",
            body: json.encode({
              "content": content,
              "accountId": creatorId,
            }));
    task = TaskEntity.fromJson(response);
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    notifyListeners();
  }

  deleteComment(TaskEntity task, Comment comment) async {
    final response = await ApiBaseHelper.instance.putProtected(
      "authenticated/deleteTaskComment?taskId=${task.taskId}&commentId=${comment.commentId}",
    );
    task = TaskEntity.fromJson(response);
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    notifyListeners();
  }

  // ===================================================================================
  // Column Methods

  createNewColumn(String columnName, editorId) async {
    final response = await ApiBaseHelper.instance
        .postProtected("authenticated/createNewColumn",
            body: json.encode({
              "columnTitle": columnName,
              "kanbanBoardId": kanban.kanbanBoardId,
              "editorId": editorId
            }));
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    notifyListeners();
  }

  updateColumn(String columnName, editorId, columnId) async {
    final response =
        await ApiBaseHelper.instance.putProtected("authenticated/updateColumn",
            body: json.encode({
              "columnTitle": columnName,
              "columnId": columnId,
              "kanbanBoardId": kanban.kanbanBoardId,
              "editorId": editorId
            }));
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    notifyListeners();
  }

  deleteColumn(int columnIdToDelete, deletorId, {transferredColumnId}) async {
    final response =
        await ApiBaseHelper.instance.putProtected("authenticated/deleteColumn",
            body: json.encode({
              "deleteColumnId": columnIdToDelete,
              "transferredColumnId": transferredColumnId,
              "deletorId": deletorId
            }));
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    notifyListeners();
  }

//========================================================================
//reordering methods
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

  reorderTaskSequenceInTaskView(TaskColumnEntity currentColumn,
      TaskColumnEntity newColumn, TaskEntity task) {
    currentColumn.listOfTasks.remove(task);
    newColumn.listOfTasks.add(task);
    task.taskColumn = newColumn;
    ApiBaseHelper.instance.putProtected(
        "authenticated/updateTaskStatus?taskId=${task.taskId}&newColumnId=${newColumn.taskColumnId}&oldColumnId=${currentColumn.taskColumnId}");
    notifyListeners();
  }

  reorderTaskColumns(editorId) async {
    String columnSequence = "";
    kanban.taskColumns.forEach((element) {
      columnSequence += "&columnIdSequence=${element.taskColumnId}";
    });
    final response = await ApiBaseHelper.instance.putProtected(
        "authenticated/rearrangeColumn?editorId=$editorId&kanbanBoardId=${kanban.kanbanBoardId}$columnSequence");
    kanban = KanbanEntity.fromJson(response);
    notifyListeners();
  }
}
