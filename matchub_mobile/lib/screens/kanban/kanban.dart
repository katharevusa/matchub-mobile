import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';

import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/kanban/task/selectTags.dart';
import 'package:matchub_mobile/screens/kanban/task/viewTask.dart';
import 'package:matchub_mobile/screens/search/search_page.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
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
    // kanban = instance.kanban;
    await instance.retrieveChannelMembers(widget.channelData['members']);
    await instance.retrieveChannelAdmins(widget.channelData['admins']);
    // await instance.retrieveLabelsByKanbanBoard();
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
    return Consumer<KanbanController>(builder: (context, controller, child) {
      List<BoardList> _lists = List<BoardList>();
      if (!loading) {
        kanban = controller.kanban;
        for (int i = 0; i < kanban.taskColumns.length; i++) {
          _lists.add(_createBoardList(kanban.taskColumns[i]));
        }
      }

      return Scaffold(
        appBar: AppBar(
            title: Text(
          widget.channelData['name'],
        )),
        backgroundColor: Color.fromARGB(255, 235, 236, 240),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : BoardView2(
                lists: _lists,
                boardViewController: boardViewController,
              ),
      );
    });
  }

  Widget buildBoardItem(TaskEntity task) {
    var kanbanController =
        Provider.of<KanbanController>(context, listen: false);
    var daysToDeadline =
        task.expectedDeadline.difference(DateTime.now()).inDays;
    var daysToDisplay = daysToDeadline.abs();
    return BoardItem(
      onStartDragItem: (int listIndex, int itemIndex, BoardItemState state) {},
      onDropItem: (int listIndex, int itemIndex, int oldListIndex,
          int oldItemIndex, BoardItemState state) {
        //Used to update our local item data
        var item = kanban.taskColumns[oldListIndex].listOfTasks[oldItemIndex];
        kanban.taskColumns[oldListIndex].listOfTasks.removeAt(oldItemIndex);
        kanban.taskColumns[listIndex].listOfTasks.insert(itemIndex, item);
        kanbanController.reorderTaskSequence(
            Provider.of<Auth>(context, listen: false).myProfile.accountId);
      },
      onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => ViewTask(task: task, kanban: kanban))).then((value) => setState((){}));
      },
      item: Container(
        constraints: BoxConstraints(
          minHeight: 80,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400].withOpacity(0.9),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${DateFormat.yMMMd().format(task.expectedDeadline)} | " +
                  (daysToDisplay == 0
                      ? "Today"
                      : "${daysToDisplay.toString()} days" +
                          (daysToDeadline.isNegative ? " ago" : "")),
              style: TextStyle(
                  color: daysToDeadline > 5
                      ? kSecondaryColor
                      : daysToDeadline > 0
                          ? Colors.orange[200]
                          : daysToDeadline == 0
                              ? Colors.red[200]
                              : Colors.grey[400],
                  fontSize: 1.4 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              task.taskTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                    child: Tags(
                      alignment: WrapAlignment.start,
                      spacing: 0,
                      runSpacing: 8,
                      itemBuilder: (index) {
                        MapEntry label =
                            task.labelAndColour.entries.toList()[index];
                        return TaskLabel(label: label);
                      },
                      itemCount: task.labelAndColour.length,
                    )),
                Flexible(flex: 1, child: buildTeamMemberRow(task.taskDoers)),
              ],
            )
          ],
        ),
      ),
    );
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

Widget buildTeamMemberRow(List members) {
  var newMembers;
  if (members.length > 3) {
    newMembers = members.sublist(1, 4);
  } else {
    newMembers = members;
  }
  return (members.isNotEmpty)
      ? Container(
          alignment: Alignment.bottomRight,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Stack(
              children: [
                ...newMembers
                    .asMap()
                    .map((i, e) => MapEntry(
                        i,
                        Transform.translate(
                            offset: Offset(i * -30.0, 0),
                            child: _buildAvatar(
                              e,
                            ))))
                    .values
                    .toList(),
                if (members.length > 3)
                  Transform.translate(
                      offset: Offset(40.0, 35),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.grey,
                        ),
                      ))
              ],
            ),
          ]))
      : Container();
}

Widget _buildAvatar(profile, {double radius = 50}) {
  return Container(
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey[400].withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3)),
        ],
        border: Border.all(color: Colors.white, width: 3),
        shape: BoxShape.circle),
    height: radius,
    width: radius,
    child: ClipOval(child: AttachmentImage(profile.profilePhoto)),
  );
}
