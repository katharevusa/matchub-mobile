import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/helpers/profile_helper.dart';

import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/kanban/task/selectTags.dart';
import 'package:matchub_mobile/screens/kanban/task/selectTaskMembers.dart';
import 'package:matchub_mobile/screens/kanban/task/viewTask.dart';
import 'package:matchub_mobile/screens/project_management/channels/channel_messages.dart';
import 'package:matchub_mobile/screens/project_management/channels/channel_settings.dart';
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
import 'board/columnCreatePopup.dart';

class KanbanView extends StatefulWidget {
  static const routeName = "kanbanboard";
  Map<String, dynamic> channelData;
  Project project;

  KanbanView({this.channelData, this.project});

  @override
  _KanbanViewState createState() => _KanbanViewState();
}

class _KanbanViewState extends State<KanbanView> {
  KanbanEntity filteredKanban;
  bool loading;
  Map<String, dynamic> filterOptions = {
    "filteredAssignees": [],
    "labels": [],
    "deadlines": []
  };
  bool toShowFilters = true;
  bool assigneeChoice = false;
  @override
  initState() {
    loading = true;
    retrieveKanban();
    super.initState();
  }

  retrieveKanban() async {
    final instance = Provider.of<KanbanController>(context, listen: false);
    await instance.retrieveKanbanByChannelId(widget.channelData['id']);
    await instance.retrieveChannelMembers(widget.channelData['members']);
    await instance.retrieveChannelAdmins(widget.channelData['admins']);
    await instance.retrieveLabelsByKanbanBoard();
    setState(() {
      loading = false;
    });
  }

  BoardView2Controller boardViewController = new BoardView2Controller();

  @override
  Widget build(BuildContext context) {
    return Consumer<KanbanController>(builder: (context, controller, child) {
      List<BoardList> _lists = List<BoardList>();
      if (!loading) {
        filteredKanban = controller.filteredKanban;
        for (int i = 0; i < filteredKanban.taskColumns.length; i++) {
          _lists.add(_createBoardList(filteredKanban.taskColumns[i]));
        }
      }

      return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: kScaffoldColor,
            // backgroundColor: kKanbanColor,
            // backgroundColor: Color(0xFF5BC2A2),
            leadingWidth: 44,
            title: ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChannelSettings(
                          channelData: widget.channelData,
                          project: widget.project))),
              title: Text(
                widget.channelData['name'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            elevation: 2,
            bottom: toShowFilters
                ? PreferredSize(
                    child: Container(
                        width: 100 * SizeConfig.widthMultiplier,
                        height: 40,
                        color: Color(0xFFFAF9FE),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(width: 20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              child: RaisedButton(
                                visualDensity: VisualDensity.compact,
                                color: filterOptions['filteredAssignees']
                                        .isNotEmpty
                                    ? Color(0xFF52459D)
                                    : Colors.blueGrey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                    filterOptions['filteredAssignees']
                                            .isNotEmpty
                                        ? (filterOptions['filteredAssignees']
                                                    .length >
                                                1
                                            ? List.of(filterOptions[
                                                    'filteredAssignees'])
                                                .reduce((e, v) {
                                                if (e is Profile &&
                                                    v is Profile) {
                                                  return "${e.name}, ${v.name}";
                                                } else if (e is String) {
                                                  return e + ", ${v.name}";
                                                } else {
                                                  return e.name;
                                                }
                                              })
                                            : filterOptions['filteredAssignees']
                                                    [0]
                                                .name)
                                        : 'Assignee',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    )),
                                onPressed: () {
                                  final kanbanController =
                                      Provider.of<KanbanController>(context,
                                          listen: false);
                                  Dialog channelMembersDialog = Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: SelectTaskMembers(
                                        kanbanController: kanbanController,
                                        listOfTaskDoers:
                                            filterOptions['filteredAssignees']),
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          channelMembersDialog).then((val) {
                                    if (val != null) {
                                      filterOptions['filteredAssignees'] = val;
                                      controller.filterBy(filterOptions);

                                      setState(() {});
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              child: RaisedButton(
                                visualDensity: VisualDensity.compact,
                                color: filterOptions['labels'].isNotEmpty
                                    ? Color(0xFF52459D)
                                    : Colors.blueGrey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('Labels',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.white)),
                                onPressed: () {
                                  final kanbanController =
                                      Provider.of<KanbanController>(context,
                                          listen: false);
                                  Dialog tagsDialog = Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0)), //this right here
                                    child: SelectTagsDialog(
                                      kanbanController: kanbanController,
                                    ),
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          tagsDialog).then((val) {
                                    setState(() {
                                      if (val != null && val.isNotEmpty) {
                                        filterOptions['labels'] =
                                            (val as Map<String, dynamic>)
                                                .keys
                                                .toList();
                                        print(filterOptions['labels']);
                                        controller.filterBy(filterOptions);
                                      } else {
                                        filterOptions['labels'].clear();
                                      }
                                    });
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            ChoiceChip(
                              backgroundColor: Colors.blueGrey[300],
                              label: Text('Deadline',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.white)),
                              selectedColor: Color(0xFF52459D),
                              labelStyle: TextStyle(color: Colors.black),
                              selected: filterOptions['deadlines'].isNotEmpty,
                              onSelected: (bool selected) {
                                setState(() {
                                  assigneeChoice = !assigneeChoice;
                                });
                              },
                            ),
                          ],
                        )),
                    preferredSize: Size(100 * SizeConfig.widthMultiplier, 40),
                  )
                : null,
            actions: [
              IconButton(
                color: Colors.black,
                icon: Icon(
                  Icons.filter_list_rounded,
                ),
                onPressed: () {
                  setState(() {
                    toShowFilters = !toShowFilters;
                  });
                  setState(() {});
                },
              ),
              IconButton(
                color: Colors.black,
                icon: Icon(Icons.message_rounded),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                          builder: (_) => ChannelMessages(
                                channelData: widget.channelData,
                                project: widget.project,
                              )));
                },
              )
            ]),
        backgroundColor: Color(0xFFFAF9FE),
        // backgroundColor: Color.fromARGB(255, 235, 236, 240),
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
        var item =
            filteredKanban.taskColumns[oldListIndex].listOfTasks[oldItemIndex];
        filteredKanban.taskColumns[oldListIndex].listOfTasks
            .removeAt(oldItemIndex);
        filteredKanban.taskColumns[listIndex].listOfTasks
            .insert(itemIndex, item);
        print(kanbanController
            .kanban.taskColumns[oldListIndex].listOfTasks.length);
        print(kanbanController
            .filteredKanban.taskColumns[oldListIndex].listOfTasks.length);
        // kanbanController.reorderTaskSequence(
        //     Provider.of<Auth>(context, listen: false).myProfile.accountId);
      },
      onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(
                builder: (_) => ViewTask(task: task, kanban: filteredKanban)))
            .then((value) => setState(() {}));
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
        child: SingleChildScrollView(
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
                            ? Colors.orange[300]
                            : daysToDeadline == 0
                                ? Colors.red[300]
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
              if (task.labelAndColour.isNotEmpty) SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                      child: Tags(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 0,
                    runSpacing: 6,
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
        var list = filteredKanban.taskColumns[oldListIndex];
        filteredKanban.taskColumns.removeAt(oldListIndex);
        filteredKanban.taskColumns.insert(listIndex, list);
        Provider.of<KanbanController>(context, listen: false)
            .reorderTaskColumns(
                Provider.of<Auth>(context, listen: false).myProfile.accountId);
      },
      backgroundColor: Colors.transparent,
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 0, left: 5),
                child: Text(
                  list.columnTitle,
                  style: TextStyle(fontSize: 20),
                ))),
        Padding(
          padding: EdgeInsets.only(top: 0, left: 5),
          child: PopupMenuButton(
              offset: Offset(0, 20),
              icon: Icon(Icons.more_vert_rounded),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                        onTap: () => showModalBottomSheet(
                            useRootNavigator: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) => ColumnCreatePopup(
                                  columnId: list.taskColumnId,
                                  columnName: list.columnTitle,
                                )),
                        dense: true,
                        leading: Icon(FlutterIcons.edit_3_fea),
                        title: Text(
                          "Rename Column",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                        onTap: () {
                          deleteColumn(this.context, list);
                          Navigator.pop(context);
                        },
                        dense: true,
                        leading: Icon(FlutterIcons.trash_alt_faw5s),
                        title: Text(
                          "Delete Column",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                      ),
                    )
                  ]),
        ),
      ],
      items: items,
    );
  }

  deleteColumn(context, TaskColumnEntity col) async {
    if (col.listOfTasks.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => new AlertDialog(
          title: new Text(
            "Delete Column",
          ),
          content:
              new Text("Are you sure you would like to delete this column"),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(ctx, true);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(ctx, false);
              },
            ),
          ],
        ),
      ).then((response) async {
        if (response) {
          await Provider.of<KanbanController>(context, listen: false)
              .deleteColumn(
                  col.taskColumnId,
                  Provider.of<Auth>(context, listen: false)
                      .myProfile
                      .accountId);
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => new AlertDialog(
          title: new Text("Column has tasks"),
          content: new Text(
              "Shift the tasks in this column to a new home before you delete it!"),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
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
                              child: buildAvatar(
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
}
