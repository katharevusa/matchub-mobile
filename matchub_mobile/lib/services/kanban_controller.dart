import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';

class KanbanController with ChangeNotifier {
  KanbanEntity kanban;
  KanbanEntity filteredKanban;
  List<Profile> channelMembers = [];
  List<Profile> channelAdmins = [];
  Map<String, dynamic> labels = {};
  Map<String, dynamic> filterOptions = {};
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
    //only used to fetch initially
    final response = await ApiBaseHelper.instance.getProtected(
        "authenticated/getKanbanBoardByChannelUid?channelUId=$channelId");
    kanban = KanbanEntity.fromJson(response);
    setFilteredKanban();
    notifyListeners();
  }

  setFilteredKanban() {
    //fking deepcopy
    filteredKanban = KanbanEntity()
      ..kanbanBoardId = kanban.kanbanBoardId
      ..projectId = kanban.kanbanBoardId
      ..kanbanBoardTitle = kanban.kanbanBoardTitle
      ..kanbanBoardDescription = kanban.kanbanBoardDescription
      ..channelUid = kanban.channelUid
      ..taskColumns = List<TaskColumnEntity>.from(
          kanban.taskColumns.map((e) => TaskColumnEntity.deepCopy(e)));
  }

  retrieveKanbanByKanbanBoardId(kanbanBoardId) async {
    final response = await ApiBaseHelper.instance.getProtected(
        "authenticated/getKanbanBoardByKanbanBoardId?kanbanBoardId=$kanbanBoardId");
    kanban = KanbanEntity.fromJson(response);
    await retrieveLabelsByKanbanBoard();
    notifyListeners();
  }

//=======================================================================
//filtering methods
  filter() async {
    List accountIds = List.of(filterOptions['filteredAssignees'])
        .map((e) => e.accountId)
        .toList();
    List filterlabels = List.of(
        (Map<String, dynamic>.from(filterOptions['filteredLabels']))
            .keys
            .toList());
    print(kanban.taskColumns[1].listOfTasks.length);
    print(filteredKanban.taskColumns[1].listOfTasks.length);
    print(kanban == filteredKanban);

    print(kanban.taskColumns[0] == filteredKanban.taskColumns[0]);
    setFilteredKanban();
    if (accountIds.length > 0) {
      filteredKanban.taskColumns.forEach(
        (column) {
          column.listOfTasks.retainWhere((task) =>
              task.taskDoers
                  .indexWhere((doer) => accountIds.contains(doer.accountId)) >=
              0);
        },
      );
    }
    if (filterOptions['filteredLabels'].length > 0) {
      filteredKanban.taskColumns.forEach((column) {
        column.listOfTasks.retainWhere((task) =>
            filterlabels.indexWhere(
                (label) => task.labelAndColour.containsKey(label)) >=
            0);
      });
    }
    if (!filterOptions['none']) {
      print(filterOptions['deadlines']);
      if (filterOptions['deadlines']['showMyTasks']) {
        filteredKanban.taskColumns.forEach((column) {
          column.listOfTasks.retainWhere(
              (task) => task.taskLeaderId == filterOptions['accountId']);
        });
      }
      DateTime today = DateTime.now();
      DateTime _lastDayOfWeek =
          today.add(new Duration(days: 7 - today.weekday));
      DateTime _lastDayOfNextWeek =
          today.add(new Duration(days: 14 - today.weekday));
      if (filterOptions['deadlines']['thisWeek']) {
        filteredKanban.taskColumns.forEach((column) {
          column.listOfTasks.retainWhere(
              (task) => task.expectedDeadline.isBefore(_lastDayOfWeek));
        });
      }
      if (filterOptions['deadlines']['nextWeek']) {
        filteredKanban.taskColumns.forEach((column) {
          column.listOfTasks.retainWhere((task) =>
              task.expectedDeadline.isBefore(_lastDayOfNextWeek) &&
              task.expectedDeadline.isAfter(_lastDayOfWeek));
        });
      }
    }
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
    filter();
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
    filter();
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
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    filter();
    notifyListeners();
  }

  updateTaskLabels(TaskEntity task) async {
    String url = "authenticated/updateLabel";
    final response = await ApiBaseHelper.instance.putProtected(url,
        body: json.encode(
            {"labelAndColour": task.labelAndColour, "taskId": task.taskId}));
    task = TaskEntity.fromJson(response);
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    filter();
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

  deleteTask(TaskEntity task, deletorId) async {
    Future.delayed(Duration(seconds: 1), () async {
      String url =
          "authenticated/deleteTask?taskId=${task.taskId}&deletorId=$deletorId&kanbanBoardId=${kanban.kanbanBoardId}";
      final response = await ApiBaseHelper.instance.putProtected(url);
      await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
      filter();
      notifyListeners();
    });
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
    filter();
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
    filter();
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
    filter();
    notifyListeners();
  }

//========================================================================
//reordering methods
  reorderTaskSequence(oldListIndex, newListIndex, newItemIndex, task, arrangerId) async {

    int indexToRemove = kanban.taskColumns[oldListIndex].listOfTasks.indexWhere((taskToMove) => taskToMove.taskId == task.taskId);
    TaskEntity taskToMove = kanban.taskColumns[oldListIndex].listOfTasks.removeAt(indexToRemove);
      
    if(filteredKanban.taskColumns[newListIndex].listOfTasks.length==1){ //adding to back of original kanban since placed in empty column
      kanban.taskColumns[newListIndex].listOfTasks.add(taskToMove);
    } else if(newItemIndex == 0){//filteredView inserted at first position, find the next item in filtered view, then find in kanban view then insert
      TaskEntity taskAfter = filteredKanban.taskColumns[newListIndex].listOfTasks[newItemIndex+1];
      int indexOfTaskAfter = kanban.taskColumns[newListIndex].listOfTasks.indexWhere((taskAfterOriginal) => taskAfterOriginal.taskId == taskAfter.taskId);
      kanban.taskColumns[newListIndex].listOfTasks.insert(indexOfTaskAfter, taskToMove);
    } else{
      TaskEntity taskBefore = filteredKanban.taskColumns[newListIndex].listOfTasks[newItemIndex-1];
      int indexOfTaskBefore = kanban.taskColumns[newListIndex].listOfTasks.indexWhere((taskBeforeOriginal) => taskBeforeOriginal.taskId == taskBefore.taskId);
      kanban.taskColumns[newListIndex].listOfTasks.insert(indexOfTaskBefore+1, taskToMove);
    }

    var newKanbanOrder = {}; //getting the state of the current updated local kanban board, and posting to backend
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
      TaskColumnEntity newColumn, TaskEntity task) async{
    currentColumn.listOfTasks.remove(task);
    newColumn.listOfTasks.add(task);
    task.taskColumn = newColumn;
    ApiBaseHelper.instance.putProtected(
        "authenticated/updateTaskStatus?taskId=${task.taskId}&newColumnId=${newColumn.taskColumnId}&oldColumnId=${currentColumn.taskColumnId}");
    await retrieveKanbanByKanbanBoardId(kanban.kanbanBoardId);
    filter();
    notifyListeners();
  }

  reorderTaskColumns(editorId) async {
    String columnSequence = "";
    filteredKanban.taskColumns.forEach((element) {
      columnSequence += "&columnIdSequence=${element.taskColumnId}";
    });
    final response = await ApiBaseHelper.instance.putProtected(
        "authenticated/rearrangeColumn?editorId=$editorId&kanbanBoardId=${kanban.kanbanBoardId}$columnSequence");
    kanban = KanbanEntity.fromJson(response);
    filter();
    notifyListeners();
  }
}
