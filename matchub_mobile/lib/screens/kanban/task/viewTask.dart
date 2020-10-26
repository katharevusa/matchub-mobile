import 'package:date_time_picker/date_time_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/attachment_helper.dart';
import 'package:matchub_mobile/helpers/upload_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/taskEntity.dart';
import 'package:matchub_mobile/models/truncatedProfile.dart';
import 'package:matchub_mobile/screens/kanban/board/boardList.dart';
import 'package:matchub_mobile/screens/kanban/task/selectStatus.dart';
import 'package:matchub_mobile/screens/kanban/task/selectTags.dart';
import 'package:matchub_mobile/screens/kanban/task/taskComment.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../kanban.dart';
import 'selectTaskMembers.dart';

class ViewTask extends StatefulWidget {
  static const routeName = "/view-task";
  TaskEntity task;
  KanbanEntity kanban;

  ViewTask({this.task, this.kanban});

  @override
  _ViewTaskState createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  UnderlineInputBorder defaultBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
  );
  TextStyle headerText = TextStyle(
      color: Colors.grey[400],
      fontSize: 1.7 * SizeConfig.heightMultiplier,
      fontWeight: FontWeight.w500);
  TextStyle displayText = AppTheme.searchLight.copyWith(
      fontFamily: "Lato",
      color: Colors.white,
      fontSize: 2 * SizeConfig.textMultiplier);
  // VideoPlayerController _controller;
  bool isTaskReporter = false;
  bool inEditMode = false;
  Profile taskReporter;
  bool isLoading;
  String commentContent = "";
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  @override
  void initState() {
    isLoading = true;
    retrieveTaskReporter();
    generateVideoThumbnails();
    super.initState();
  }

  Map<String, dynamic> vidThumnails = {};

  retrieveTaskReporter() async {
    int taskLeaderId = widget.task.taskLeaderId;
    final kanbanController =
        Provider.of<KanbanController>(context, listen: false);
    if (taskLeaderId == null) {
      taskReporter = null;
    } else {
      taskReporter =
          await kanbanController.retrieveTaskReporterById(taskLeaderId);
    }
    final myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    if (kanbanController.channelAdmins.indexWhere(
                (element) => element.accountId == myProfile.accountId) >=
            0 ||
        (taskReporter != null &&
            taskReporter.accountId == myProfile.accountId)) {
      isTaskReporter = true;
    }
    setState(() {
      isLoading = false;
    });
  }

  generateVideoThumbnails() async {
    for (var doc in widget.task.documents.entries) {
      if (path.extension(doc.key) == '.mp4') {
        // print("sdfsdff");
        // _controller = VideoPlayerController.network(
        //   "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")
        //     // ApiBaseHelper.instance.baseUrl + doc.value.substring(30))
        //   ..initialize().then((_) {
        //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        //     setState(() {
        //       print("sdfsdff");
        //     });
        //   });
        // vidThumnails['videoPath'] = (await VideoThumbnail.thumbnailFile(
        //   video: doc.value,
        //   thumbnailPath: (await getTemporaryDirectory()).path,
        //   imageFormat: ImageFormat.WEBP,
        //   maxWidth: 140,
        //   quality: 75,
        // ));
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.kanban = Provider.of<KanbanController>(context).kanban;
    var colIndex = widget.kanban.taskColumns
        .indexWhere((e) => e.columnTitle == widget.task.taskColumn.columnTitle);
    widget.task = widget.kanban.taskColumns[colIndex].listOfTasks
        .firstWhere((element) => element.taskId == widget.task.taskId);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFF2c2e45),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF2c2e45),
          title: Text(
            "Task Details",
            style: AppTheme.searchLight.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 2 * SizeConfig.textMultiplier),
          ),
          actions: [
            if (inEditMode) ...[
              IconButton(
                icon: Icon(Icons.edit_outlined, color: kKanbanColor),
                onPressed: () => setState(() => inEditMode = !inEditMode),
              ),
              FlatButton(
                  onPressed: () async {
                    await Provider.of<KanbanController>(context, listen: false)
                        .updateTask(
                      widget.task,
                    );
                    setState(() {
                      inEditMode = !inEditMode;
                    });
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kKanbanColor,
                        fontSize: 2 * SizeConfig.textMultiplier),
                  )),
            ],
            if (isTaskReporter && !inEditMode)
              PopupMenuButton(
                  offset: Offset(0, 20),
                  icon: Icon(Icons.more_vert_rounded),
                  itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            visualDensity: VisualDensity.compact,
                            onTap: () {
                              setState(() => inEditMode = !inEditMode);
                              Navigator.pop(context);
                            },
                            dense: true,
                            leading: Icon(FlutterIcons.edit_3_fea),
                            title: Text(
                              "Edit Task",
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.8),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            visualDensity: VisualDensity.compact,
                            onTap: () async {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              Provider.of<KanbanController>(context,
                                      listen: false)
                                  .deleteTask(
                                      widget.task,
                                      Provider.of<Auth>(context, listen: false)
                                          .myProfile
                                          .accountId);
                            },
                            dense: true,
                            leading: Icon(FlutterIcons.trash_alt_faw5s),
                            title: Text(
                              "Delete Task",
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.8),
                            ),
                          ),
                        )
                      ]),
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Form(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...buildTaskInfo(),
                    buildTaskDeadline(),
                    ...buildTaskStatus(),
                    ...buildTaskReporter(),
                    ...buildTaskAssignees(),
                    // _controller.value.initialized
                    //     ? AspectRatio(
                    //         aspectRatio: _controller.value.aspectRatio,
                    //         child: VideoPlayer(_controller),
                    //       )
                    //     : Container(),
                    //Attachment onwards cannot abstract out; too bad
                    if (widget.task.documents.isNotEmpty || inEditMode) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Attachments", style: headerText),
                      ),
                      if (widget.task.documents.isNotEmpty)
                        Container(
                          height: 90,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.task.documents.length,
                            itemBuilder: (_, index) {
                              var document =
                                  widget.task.documents.entries.toList()[index];
                              var fileName;
                              if (path.extension(document.key) == '.mp4') {
                                fileName = "Video";
                              } else if (path.extension(document.key) ==
                                      '.jpg' ||
                                  path.extension(document.key) == '.png') {
                                fileName = "Image";
                              } else {
                                fileName = document.key;
                              }
                              return GestureDetector(
                                onTap: () async {
                                  String url = ApiBaseHelper.instance.baseUrl +
                                      document.value.substring(30);
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                onLongPress: () {
                                  if (inEditMode) {
                                    showMenu(
                                      position: RelativeRect.fromLTRB(
                                          (index.toDouble() + 1) * (140 + 10),
                                          80 * SizeConfig.heightMultiplier,
                                          SizeConfig.widthMultiplier * 100 -
                                              index.toDouble() * (140 / 2),
                                          0),
                                      items: <PopupMenuEntry>[
                                        PopupMenuItem(
                                          value: "del",
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            onTap: () async {
                                              await Provider.of<
                                                          KanbanController>(
                                                      context,
                                                      listen: false)
                                                  .deleteDocuments(
                                                      [document.key],
                                                      widget.task);
                                              Navigator.pop(context);
                                            },
                                            dense: true,
                                            leading: Icon(
                                                FlutterIcons.trash_alt_faw5s,
                                                color: Colors.grey[700]),
                                            title: Text("Remove",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.8)),
                                          ),
                                        )
                                      ],
                                      context: context,
                                    );
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            0.5 * SizeConfig.heightMultiplier),
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey[100],
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            image: (fileName == "Video" &&
                                                    vidThumnails.containsKey(
                                                        document.value))
                                                ? MemoryImage(vidThumnails[
                                                    document.value])
                                                : fileName == "Image"
                                                    ? NetworkImage(ApiBaseHelper
                                                            .instance.baseUrl +
                                                        document.value
                                                            .substring(30))
                                                    : AssetImage(
                                                        "assets/images/announcement.png"),
                                            fit: BoxFit.cover)),
                                    height: 90,
                                    width: 140,
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 9, vertical: 16),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 25,
                                            child:
                                                getDocumentImage(document.key)),
                                        SizedBox(width: 5),
                                        Text(fileName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    )),
                              );
                            },
                          ),
                        ),
                      if (inEditMode) ...[
                        FlatButton(
                            onPressed: () => showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0),
                                          topLeft: Radius.circular(15.0)),
                                    ),
                                    context: context,
                                    builder: (ctx) {
                                      return AttachmentPopup(
                                        widget: widget,
                                      );
                                    }).then((value) async {
                                  if (value != null) {
                                    print(value.path);
                                    await uploadSinglePic(
                                      value,
                                      "${ApiBaseHelper.instance.baseUrl}authenticated/uploadDocuments?taskId=${widget.task.taskId}",
                                      Provider.of<Auth>(context, listen: false)
                                          .accessToken,
                                      "documents",
                                    );
                                    await Provider.of<KanbanController>(context,
                                            listen: false)
                                        .retrieveKanbanByKanbanBoardId(
                                            widget.kanban.kanbanBoardId);
                                  }
                                }),
                            child: Row(
                              children: [
                                Icon(Icons.attach_email_rounded,
                                    color: kKanbanColor),
                                SizedBox(width: 10),
                                Text("Add another",
                                    style: TextStyle(
                                        fontSize: 14, color: kKanbanColor))
                              ],
                            )),
                      ]
                    ]
                  ],
                ),
              ),
              SizedBox(height: 20),
              buildCommentSection(),
              SizedBox(height: 60),
            ])),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey[200]))),
              margin: EdgeInsets.all(0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              alignment: Alignment.bottomCenter,
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        focusNode: commentFocus,
                        onEditingComplete: () => commentFocus.unfocus(),
                        onChanged: (val) {
                          commentContent = val.trim();
                        },
                        controller: commentController,
                        maxLines: 6,
                        minLines: 1,
                        decoration: InputDecoration(
                            border: defaultBorder,
                            enabledBorder: defaultBorder,
                            focusedBorder: defaultBorder,
                            hintText: "Leave a comment...",
                            hintStyle: TextStyle(color: Colors.grey[700]))),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12),
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () async {
                          if (commentContent.isNotEmpty) {
                            await Provider.of<KanbanController>(context,
                                    listen: false)
                                .addComment(
                                    widget.task,
                                    commentContent,
                                    Provider.of<Auth>(context, listen: false)
                                        .myProfile
                                        .accountId);
                            setState(() {
                              commentController.clear();
                            });
                          }
                        },
                        color: kKanbanColor,
                        child: Text(
                          "Post",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 2 * SizeConfig.textMultiplier),
                        )),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget buildCommentSection() {
    return Container(
      width: 100 * SizeConfig.widthMultiplier,
      // height: 50 * SizeConfig.heightMultiplier,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          )),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text("Comments",
                    style: TextStyle(
                        fontSize: 2.2 * SizeConfig.textMultiplier,
                        color: Colors.grey[850])),
              ),
            ],
          ),
        ),
        if (widget.task.comments.isEmpty) ...[
          Container(
            height: 180,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/no-comment2.png",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text("Be the first to leave a comment",
                style: TextStyle(
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    color: Colors.grey[700])),
          ),
        ],
        ListView.separated(
            reverse: true,
            separatorBuilder: (_, __) => Divider(),
            itemCount: widget.task.comments.length,
            itemBuilder: (_, idx) {
              return TaskCommentCard(
                  comment: widget.task.comments[idx], task: widget.task);
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics()),
        SizedBox(height: 40),
      ]),
    );
  }

  List<Widget> buildTaskInfo() {
    return [
      TextFormField(
          enableInteractiveSelection: false,
          initialValue: widget.task.taskTitle,
          readOnly: !inEditMode,
          onChanged: (value) {
            widget.task.taskTitle = value;
          },
          validator: (val) {
            if (val.isEmpty) {
              return "Please input a task name";
            }
          },
          style: displayText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              border: defaultBorder,
              enabledBorder: defaultBorder,
              focusedBorder: defaultBorder,
              labelText: "Task Name",
              labelStyle: headerText)),
      TextFormField(
          maxLines: 6,
          minLines: 1,
          enableInteractiveSelection: inEditMode,
          initialValue: widget.task.taskDescription,
          readOnly: !inEditMode,
          style: displayText,
          onChanged: (value) {
            widget.task.taskDescription = value;
          },
          decoration: InputDecoration(
              border: defaultBorder,
              enabledBorder: defaultBorder,
              focusedBorder: defaultBorder,
              labelText: "Task Description",
              labelStyle: headerText)),
    ];
  }

  List<Widget> buildTaskStatus() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text("Status", style: headerText),
      ),
      FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Color(0xFFF26950),
        onPressed: () {
          if (inEditMode) {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0)),
                ),
                context: context,
                builder: (ctx) {
                  return SelectStatusPopup(
                    widget: widget,
                  );
                });
          }
        },
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 4),
            Text(
              widget.task.taskColumn.columnTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 2 * SizeConfig.textMultiplier),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            )
          ],
        ),
      ),
      GestureDetector(
        onTap: inEditMode ? routeToTagsDialog : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text("Labels", style: headerText),
          ),
          if (widget.task.labelAndColour.isEmpty)
            DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(5),
              padding: EdgeInsets.all(6),
              color: Colors.grey[100],
              child: Text("None",
                  style: headerText.copyWith(color: Colors.grey[100])),
            ),
          if (widget.task.labelAndColour.isNotEmpty)
            Container(
              constraints: BoxConstraints(minHeight: 25, maxHeight: 25),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.task.labelAndColour.length,
                  itemBuilder: (context, index) {
                    MapEntry label =
                        widget.task.labelAndColour.entries.toList()[index];
                    return TaskLabel(label: label);
                  }),
            ),
        ]),
      ),
    ];
  }

  List<Widget> buildTaskReporter() {
    //Display only. logic in select task reporter
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text("Reporter", style: headerText),
      ),
      isLoading
          ? Container()
          : Row(
              children: [
                if (taskReporter == null) ...[
                  if (inEditMode) ...[
                    drawAddButton(onTap: () => selectTaskReporter()),
                    SizedBox(width: 10),
                  ],
                  if (!inEditMode)
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(5),
                      padding: EdgeInsets.all(6),
                      color: Colors.grey[100],
                      child: Text("Not Yet Assigned",
                          style: headerText.copyWith(color: Colors.grey[100])),
                    )
                ],
                if (taskReporter != null) ...[
                  GestureDetector(
                    onTap: () => inEditMode ? selectTaskReporter() : null,
                    child: Row(
                      children: [
                        _buildAvatar(taskReporter, radius: 40),
                        SizedBox(width: 10),
                        Text(taskReporter.name,
                            style:
                                headerText.copyWith(color: Colors.grey[100])),
                      ],
                    ),
                  ),
                ]
              ],
            )
    ];
  }

  List<Widget> buildTaskAssignees() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text("Assignees", style: headerText),
      ),
      (widget.task.taskDoers.isNotEmpty)
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => inEditMode ? routeToSelectMembers() : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: SizeConfig.widthMultiplier * 80,
                    child: Stack(
                      children: [
                        ...widget.task.taskDoers
                            .asMap()
                            .map((i, e) => MapEntry(
                                i,
                                Transform.translate(
                                    offset: Offset(i * 50.0, 0),
                                    child: _buildAvatar(
                                      e,
                                    ))))
                            .values
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                if (inEditMode) ...[
                  drawAddButton(
                      members: widget.task.taskDoers,
                      onTap: routeToSelectMembers),
                  SizedBox(width: 10),
                ],
                if (!inEditMode)
                  DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(5),
                      padding: EdgeInsets.all(6),
                      color: Colors.grey[100],
                      child: Text("Not Yet Assigned",
                          style: headerText.copyWith(color: Colors.grey[100]))),
              ],
            )
    ];
  }

  Widget buildTaskDeadline() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Theme(
            data: AppTheme.lightTheme.copyWith(
              colorScheme: ColorScheme.light(primary: kSecondaryColor),
            ),
            child: DateTimePicker(
              readOnly: true,
              decoration: InputDecoration(
                icon: Icon(
                  FlutterIcons.calendar_fea,
                  color: Colors.grey[400],
                ),
                border: defaultBorder,
                enabledBorder: defaultBorder,
                focusedBorder: defaultBorder,
                labelText: 'Date Created',
                labelStyle: headerText,
              ),
              style: displayText,
              initialValue: widget.task.createdTime.toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onChanged: (val) {
                print(val);
                widget.task.expectedDeadline = DateTime.parse(val);
              },
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Icon(
          FlutterIcons.dash_oct,
          color: Colors.grey[400],
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
          flex: 1,
          child: Theme(
            data: AppTheme.lightTheme.copyWith(
              colorScheme: ColorScheme.light(primary: kSecondaryColor),
            ),
            child: DateTimePicker(
              readOnly: !inEditMode,
              icon: Icon(
                FlutterIcons.calendar_fea,
                color: Colors.grey[400],
              ),
              decoration: InputDecoration(
                border: defaultBorder,
                icon: Icon(
                  FlutterIcons.calendar_fea,
                  color: Colors.grey[400],
                ),
                enabledBorder: defaultBorder,
                focusedBorder: defaultBorder,
                labelText: 'Deadline',
                labelStyle: headerText,
              ),
              initialValue: widget.task.expectedDeadline.toString(),
              style: displayText,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onChanged: (val) {
                // widget.filterOptions['endDate'] = val;
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  //Task Labels Updating
  routeToTagsDialog() {
    final kanbanController =
        Provider.of<KanbanController>(context, listen: false);
    Dialog tagsDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: SelectTagsDialog(
        existingLabels: widget.task.labelAndColour,
          kanbanController: kanbanController, ),
    );
    showDialog(context: context, builder: (BuildContext context) => tagsDialog)
        .then((val) {
      if (val != null) {
        setState(() {
          widget.task.labelAndColour = val;
        });
        kanbanController.updateTaskLabels(widget.task);
      }
    });
  }

  //Task Doers Updating
  routeToSelectMembers() {
    final kanbanController =
        Provider.of<KanbanController>(context, listen: false);
    Dialog channelMembersDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SelectTaskMembers(actionString: "Assign",
          kanbanController: kanbanController, listOfTaskDoers: widget.task.taskDoers),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => channelMembersDialog).then((val) {
      if (val != null) {
        setState(() {
          widget.task.taskDoers = val;
          kanbanController.updateTaskDoers(val, widget.task,
              Provider.of<Auth>(context, listen: false).myProfile.accountId);
        });
      }
    });
  }

  //Task Reporter Updating
  selectTaskReporter() {
    final kanbanController =
        Provider.of<KanbanController>(context, listen: false);
    Dialog channelMembersDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SelectTaskMember(
        kanbanController: kanbanController,
        initialTaskLeader: taskReporter,
      ),
    );
    showDialog(
            context: context,
            builder: (BuildContext context) => channelMembersDialog)
        .then((val) async {
      if (val != null) {
        if (val == false) {
          widget.task.taskLeaderId = null;
        } else {
          widget.task.taskLeaderId = val.accountId;
        }
        await kanbanController.updateTask(
          widget.task,
        );
        setState(() {
          isLoading = true;
        });
        await retrieveTaskReporter();
      }
    });
  }

  drawAddButton({members = const [], double radius = 60.0, onTap = null}) {
    return Transform.translate(
        offset: Offset(members.length * 50.0, 0),
        child: Container(
          decoration:
              BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
          height: radius,
          width: radius,
          child: IconButton(
            icon: Icon(FlutterIcons.plus_fea),
            onPressed: () => onTap(),
            color: Colors.blueGrey[600],
          ),
        ));
  }

  Widget _buildAvatar(profile, {double radius = 60.0}) {
    return Tooltip(
      preferBelow: false,
      message: profile.name,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300], width: 2),
            shape: BoxShape.circle),
        height: radius,
        width: radius,
        child: ClipOval(child: AttachmentImage(profile.profilePhoto)),
      ),
    );
  }

  Widget getDocumentImage(String fileName) {
    int ext = 0;
    switch (path.extension(fileName)) {
      case '.docx':
        {
          ext = 0;
        }
        break;
      case '.doc':
        {
          ext = 0;
        }
        break;
      case '.ppt':
        {
          ext = 1;
        }
        break;
      case '.xlsx':
        {
          ext = 2;
        }
        break;
      case '.pdf':
        {
          ext = 3;
        }
        break;
      default:
        ext = 4;
    }
    return Image.asset(
      iconList[ext],
      fit: BoxFit.cover,
    );
  }
}

final List<String> iconList = [
  "assets/icons/word.png",
  "assets/icons/ppt.png",
  "assets/icons/excel.png",
  "assets/icons/pdf.png",
  "assets/icons/video.png",
];
