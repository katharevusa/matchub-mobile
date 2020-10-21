import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

import 'boardItem.dart';
import 'boardView.dart';

typedef void OnDropList(int listIndex, int oldListIndex);
typedef void OnTapList(int listIndex);
typedef void OnStartDragList(int listIndex);

class BoardList extends StatefulWidget {
  final String title;
  final List<Widget> header;
  final Widget footer;
  final List<BoardItem> items;
  final Color backgroundColor;
  final Color headerBackgroundColor;
  final BoardView2State boardView;
  final OnDropList onDropList;
  final OnTapList onTapList;
  final OnStartDragList onStartDragList;
  final bool draggable;

  const BoardList({
    Key key,
    this.header,
    this.title,
    this.items,
    this.footer,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.boardView,
    this.draggable = true,
    this.index,
    this.onDropList,
    this.onTapList,
    this.onStartDragList,
  }) : super(key: key);

  final int index;

  @override
  State<StatefulWidget> createState() {
    return BoardListState();
  }
}

class BoardListState extends State<BoardList> {
  List<BoardItemState> itemStates = List<BoardItemState>();
  ScrollController boardListController = new ScrollController();

  void onDropList(int listIndex) {
    widget.boardView.setState(() {
      if (widget.onDropList != null) {
        widget.onDropList(listIndex, widget.boardView.startListIndex);
      }
      widget.boardView.draggedListIndex = null;
    });
  }

  void _startDrag(Widget item, BuildContext context) {
    if (widget.boardView != null && widget.draggable) {
      widget.boardView.setState(() {
        if (widget.onStartDragList != null) {
          widget.onStartDragList(widget.index);
        }
        widget.boardView.startListIndex = widget.index;
        widget.boardView.height = context.size.height;
        widget.boardView.draggedListIndex = widget.index;
        widget.boardView.draggedItemIndex = null;
        widget.boardView.draggedItem = item;
        widget.boardView.onDropList = onDropList;
        widget.boardView.run();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidgets = new List<Widget>();
    if (widget.header != null) {
      Color headerBackgroundColor = Color.fromARGB(255, 255, 255, 255);
      if (widget.headerBackgroundColor != null) {
        headerBackgroundColor = widget.headerBackgroundColor;
      }
      listWidgets.add(GestureDetector(
          onTap: () {
            if (widget.onTapList != null) {
              widget.onTapList(widget.index);
            }
          },
          onTapDown: (otd) {
            if (widget.draggable) {
              RenderBox object = context.findRenderObject();
              Offset pos = object.localToGlobal(Offset.zero);
              widget.boardView.initialX = pos.dx;
              widget.boardView.initialY = pos.dy;

              widget.boardView.rightListX = pos.dx + object.size.width;
              widget.boardView.leftListX = pos.dx;
            }
          },
          onTapCancel: () {},
          onLongPress: () {
            if (!widget.boardView.widget.isSelecting && widget.draggable) {
              _startDrag(widget, context);
            }
          },
          child: Container(
            color: widget.headerBackgroundColor,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.header),
          )));
    }
    if (widget.items != null) {
      listWidgets.add(Container(
          child: Flexible(
              fit: FlexFit.loose,
              child: new ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                controller: boardListController,
                itemCount: widget.items.length + 1,
                itemBuilder: (ctx, index) {
                  if (index >= widget.items.length) {
                    return InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3)),
                          width: 100 * SizeConfig.widthMultiplier,
                          height: 40,
                          child: Row(children: [
                            Icon(Icons.add),
                            Text(
                              "Create Task",
                              style:
                                  AppTheme.buttonLight.copyWith(fontSize: 16),
                            )
                          ])),
                      onTap: () => showModalBottomSheet(
                          useRootNavigator: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) =>
                              TaskCreatePopup(columnList: widget)),
                    );
                  }
                  if (widget.items[index].boardList == null ||
                      widget.items[index].index != index ||
                      widget.items[index].boardList.widget.index !=
                          widget.index ||
                      widget.items[index].boardList != this) {
                    widget.items[index] = new BoardItem(
                      boardList: this,
                      item: widget.items[index].item,
                      draggable: widget.items[index].draggable,
                      index: index,
                      onDropItem: widget.items[index].onDropItem,
                      onTapItem: widget.items[index].onTapItem,
                      onDragItem: widget.items[index].onDragItem,
                      onStartDragItem: widget.items[index].onStartDragItem,
                    );
                  }

                  if (widget.boardView.draggedItemIndex == index &&
                      widget.boardView.draggedListIndex == widget.index) {
                    return Opacity(
                      opacity: 0.0,
                      child: widget.items[index],
                    );
                  } else {
                    return widget.items[index];
                  }
                },
              ))));
    }

    if (widget.footer != null) {
      listWidgets.add(widget.footer);
    }

    Color backgroundColor = Color.fromARGB(255, 255, 255, 255);

    if (widget.backgroundColor != null) {
      backgroundColor = widget.backgroundColor;
    }
    if (widget.boardView.listStates.length > widget.index) {
      widget.boardView.listStates.removeAt(widget.index);
    }
    widget.boardView.listStates.insert(widget.index, this);

    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: listWidgets,
        ));
  }
}

class TaskCreatePopup extends StatefulWidget {
  final BoardList columnList;

  const TaskCreatePopup({
    Key key,
    @required this.columnList,
  }) : super(key: key);

  @override
  _TaskCreatePopupState createState() => _TaskCreatePopupState();
}

class _TaskCreatePopupState extends State<TaskCreatePopup> {
  FocusNode taskNameFocus = new FocusNode();
  Map<String, dynamic> newTask = {
    "taskTitle": null,
    "taskDescription": null,
    "taskLeaderId": null,
    "expectedDeadline": null,
    "taskColumnId": null,
    "taskCreatorOrEditorId": null,
    "kanbanboardId": null,
  };
  final GlobalKey<FormState>  _formController = GlobalKey();
  Profile selectedTaskLeader;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(taskNameFocus));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kanban = Provider.of<KanbanController>(context, listen: false).kanban;
    newTask['kanbanboardId'] = kanban.kanbanBoardId;
    newTask['taskCreatorOrEditorId'] =
        Provider.of<Auth>(context, listen: false).myProfile.accountId;
    newTask['taskColumnId'] = kanban.taskColumns
        .firstWhere((element) => element.columnTitle == widget.columnList.title)
        .taskColumnId;
    newTask['kanbanboardId'] = kanban.kanbanBoardId;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 200,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formController,
                      child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(
                    children: [
                      Icon(
                        FlutterIcons.columns_faw5s,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 10),
                      Text(widget.columnList.title,
                          style: AppTheme.searchLight.copyWith(
                              color: Colors.grey[400],
                              fontSize: 2 * SizeConfig.textMultiplier)),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: FlatButton(
                        color: kKanbanColor,
                        onPressed: () async {
                           _formController.currentState.save();
                          if (newTask['taskTitle'] != null &&
                              newTask['expectedDeadline'] != null) {
                            await Provider.of<KanbanController>(context,
                                    listen: false)
                                .createTask(newTask);
                            Navigator.pop(context);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Create Task",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 2 * SizeConfig.textMultiplier),
                        )),
                  ),
                ]),
                SizedBox(height: 6),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a task name";
                    }
                  },
                  onChanged: (val) {
                    newTask['taskTitle'] = val;
                  },
                  textCapitalization: TextCapitalization.sentences,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: taskNameFocus,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Task Name...",
                      hintStyle: TextStyle(color: Colors.grey[700])),
                ),
                Row(children: [
                  FlatButton(
                    onPressed: () {
                      final kanbanController =
                          Provider.of<KanbanController>(context, listen: false);
                      Dialog channelMembersDialog = Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0)), //this right here
                        child:
                            SelectTaskMember(kanbanController: kanbanController),
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              channelMembersDialog).then((val) {
                        if (val != null) {
                          setState(() {
                            selectedTaskLeader = val;
                            newTask['taskLeaderId'] =
                                selectedTaskLeader.accountId;
                            print(selectedTaskLeader);
                          });
                        }
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Icon(FlutterIcons.user_circle_faw5s,
                            color: Colors.grey[400]),
                        SizedBox(
                          width: 4,
                        ),
                        if (selectedTaskLeader == null)
                          Text("Unassigned",
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 1.6 * SizeConfig.textMultiplier)),
                        if (selectedTaskLeader != null)
                          Text(selectedTaskLeader.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 1.6 * SizeConfig.textMultiplier)),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Icon(FlutterIcons.calendar_fea, color: Colors.grey[400]),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        width: 200,
                        child: Theme(
                          data: AppTheme.lightTheme.copyWith(
                            colorScheme:
                                ColorScheme.light(primary: kSecondaryColor),
                          ),
                          child: DateTimePicker(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please input a deadline";
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelText: 'Deadline',
                              labelStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 1.6 * SizeConfig.textMultiplier),
                            ),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 1.6 * SizeConfig.textMultiplier),
                            onChanged: (val) {
                              newTask['expectedDeadline'] = val + "T00:00:00";
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectTaskMember extends StatefulWidget {
  SelectTaskMember({
    Key key,
    @required this.kanbanController,
  }) : super(key: key);

  final KanbanController kanbanController;

  @override
  _SelectTaskMemberState createState() => _SelectTaskMemberState();
}

class _SelectTaskMemberState extends State<SelectTaskMember> {
  Profile selectedTaskLeader;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: SizeConfig.heightMultiplier * 50,
        width: SizeConfig.widthMultiplier * 80,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20, right: 20, bottom: 10),
            child: Text(
                "Channel Members - ${widget.kanbanController.channelMembers.length.toString()}",
                style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 2.2 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w700)),
          ),
          Scrollbar(
            radius: Radius.circular(5),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.kanbanController.channelMembers.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  setState(() {
                    selectedTaskLeader =
                        widget.kanbanController.channelMembers[index];
                    print(selectedTaskLeader);
                  });
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedTaskLeader ==
                                  widget.kanbanController.channelMembers[index]
                              ? kKanbanColor
                              : Colors.grey[300],
                          width: 3),
                      shape: BoxShape.circle),
                  height: 50,
                  width: 50,
                  child: ClipOval(
                      child: AttachmentImage(widget.kanbanController
                          .channelMembers[index].profilePhoto)),
                ),
                title: Text(widget.kanbanController.channelMembers[index].name,
                    style: TextStyle(
                        color: selectedTaskLeader ==
                                widget.kanbanController.channelMembers[index]
                            ? kKanbanColor
                            : Colors.grey[900],
                        fontSize: 1.8 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ]),
      ),
      Positioned(
        bottom: 20,
        right: 5 * SizeConfig.widthMultiplier,
        left: 5 * SizeConfig.widthMultiplier,
        child: FlatButton(
          color: kKanbanColor,
          onPressed: () => Navigator.pop(context, selectedTaskLeader),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 60 * SizeConfig.widthMultiplier,
              child: Text(
                "Assign Task Leader",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 2 * SizeConfig.textMultiplier),
              )),
        ),
      ),
    ]);
  }
}
