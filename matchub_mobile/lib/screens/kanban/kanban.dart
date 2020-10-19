import 'package:flutter/material.dart';

import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/kanban/task/viewTask.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:provider/provider.dart';

import 'board/boardItem.dart';
import 'board/boardList.dart';
import 'board/boardView.dart';
import 'board/boardViewController.dart';

class KanbanView extends StatefulWidget {
  Map<String, dynamic> channelData;
  Project project;

  KanbanView({this.channelData, this.project});

  @override
  _KanbanViewState createState() => _KanbanViewState();
}

class _KanbanViewState extends State<KanbanView> {
  // List<TaskColumnEntity> _listData = [
  //   TaskColumnEntity(columnTitle: "To Do", listOfTasks: [
  //     TaskEntity(
  //         taskTitle: "Help God",
  //         taskColumn: TaskColumnEntity(columnTitle: "To Do")),
  //     TaskEntity(taskTitle: "Help Allah"),
  //     TaskEntity(taskTitle: "Help juah"),
  //   ]),
  //   TaskColumnEntity(columnTitle: "In Progress"),
  //   TaskColumnEntity(columnTitle: "Completed"),
  //   TaskColumnEntity(columnTitle: "Finalised"),
  // ];
  KanbanEntity kanban;
  bool loading;
  @override
  initState() {
    loading = true;
    retrieveKanban();
    super.initState();
  }

  retrieveKanban() async {
    final instance = Provider.of<KanbanController>(context, listen: false);
    await instance.retrieveKanbanByChannelId(widget.channelData['id']);
    kanban = instance.kanban;
    await instance.retrieveChannelMembers(widget.channelData['members']);
    setState(() {
      loading = false;
    });
  }

  BoardView2Controller boardViewController = new BoardView2Controller();

  @override
  Widget build(BuildContext context) {
    // _listData[0].listOfTasks[0].taskDoers =
    //     Provider.of<ManageProject>(context).managedProject.teamMembers;
    // _listData[0].listOfTasks[0].taskLeader =
    //     Provider.of<Auth>(context).myProfile;
    // for (int i = 0; i < kanban.taskColumns.length; i++) {
    //   _lists.add(_createBoardList(kanban.taskColumns[i]));
    // }
    return loading
        ? Scaffold(
            appBar: AppBar(
                title: Text(
              widget.channelData['name'],
            )),
            body: Center(child: CircularProgressIndicator()))
        : Consumer<KanbanController>(builder: (context, controller, child) {
            List<BoardList> _lists = List<BoardList>();
            for (int i = 0; i < kanban.taskColumns.length; i++) {
              _lists.add(_createBoardList(kanban.taskColumns[i]));
            }

            return Scaffold(
              appBar: AppBar(
                  title: Text(
                widget.channelData['name'],
              )),
              backgroundColor: Color.fromARGB(255, 235, 236, 240),
              body: BoardView2(
                lists: _lists,
                boardViewController: boardViewController,
                width: 80 * SizeConfig.widthMultiplier,
              ),
            );
          });
  }

  Widget buildBoardItem(TaskEntity task) {
    return BoardItem(
        onStartDragItem:
            (int listIndex, int itemIndex, BoardItemState state) {},
        onDropItem: (int listIndex, int itemIndex, int oldListIndex,
            int oldItemIndex, BoardItemState state) {
          //Used to update our local item data
          var item = kanban.taskColumns[oldListIndex].listOfTasks[oldItemIndex];
          kanban.taskColumns[oldListIndex].listOfTasks.removeAt(oldItemIndex);
          kanban.taskColumns[listIndex].listOfTasks.insert(itemIndex, item);
          print(item);
        },
        onTapItem:
            (int listIndex, int itemIndex, BoardItemState state) async {},
        item: GestureDetector(
          onTap: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                  builder: (_) => ViewTask(task: task, kanban: kanban))),
          child: Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(task.taskTitle),
            ),
          ),
        ));
  }

  Widget _createBoardList(TaskColumnEntity list) {
    List<BoardItem> items = new List();
    for (int i = 0; i < list.listOfTasks.length; i++) {
      items.insert(i, buildBoardItem(list.listOfTasks[i]));
    }
    return BoardList(
      title: list.columnTitle,
      onStartDragList: (int listIndex) {},
      onTapList: (int listIndex) async {},
      onDropList: (int listIndex, int oldListIndex) {
        //Update our local list data
        var list = kanban.taskColumns[oldListIndex];
        kanban.taskColumns.removeAt(oldListIndex);
        kanban.taskColumns.insert(listIndex, list);
        print(items.map((e) => e.item).toString());
      },
      backgroundColor: Colors.transparent,
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.columnTitle,
                  style: TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );
  }
}
