import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/taskEntity.dart';
import 'package:matchub_mobile/models/truncatedProfile.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

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

  bool isTaskReporter = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFF2c2e45),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF2c2e45),
          // automaticallyImplyLeading: false,

          title: Text(
            "Task Details",
            style: AppTheme.searchLight.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 2 * SizeConfig.textMultiplier),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: kKanbanColor),
              onPressed: () => setState(() => isTaskReporter = !isTaskReporter),
            ),
            FlatButton(
                child: Text(
              "Save",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kKanbanColor,
                  fontSize: 2 * SizeConfig.textMultiplier),
            ))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
              child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      enableInteractiveSelection: false,
                      initialValue: "My First Task",
                      readOnly: isTaskReporter,
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
                      initialValue: "My First Description",
                      readOnly: isTaskReporter,
                      style: displayText,
                      decoration: InputDecoration(
                          border: defaultBorder,
                          enabledBorder: defaultBorder,
                          focusedBorder: defaultBorder,
                          labelText: "Task Description",
                          labelStyle: headerText)),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Theme(
                          data: AppTheme.lightTheme.copyWith(
                            colorScheme:
                                ColorScheme.light(primary: kSecondaryColor),
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
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            onChanged: (val) {
                              // widget.filterOptions['endDate'] = val;
                              setState(() {});
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
                            colorScheme:
                                ColorScheme.light(primary: kSecondaryColor),
                          ),
                          child: DateTimePicker(
                            readOnly: isTaskReporter,
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
                  ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("Labels", style: headerText),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("Reporter", style: headerText),
                  ),
                  Row(
                    children: [
                      _buildAvatar(widget.task.taskLeader, radius: 40),
                      SizedBox(width: 10),
                      Text(widget.task.taskLeader.name,
                          style: headerText.copyWith(color: Colors.grey[100])),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("Assignees", style: headerText),
                  ),
                  ...buildTeamMemberRow(widget.task.taskDoers),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100 * SizeConfig.widthMultiplier,
              // height: 50 * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("Comments",
                                style: TextStyle(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    color: Colors.grey[850])),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {},
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                maxLines: 6,
                                minLines: 1,
                                decoration: InputDecoration(
                                    border: defaultBorder,
                                    enabledBorder: defaultBorder,
                                    focusedBorder: defaultBorder,
                                    hintText: "Comment...",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]))),
                          ),
                        ],
                      ),
                    ),
                  ]),
            )
          ])),
        ),
      ),
    );
  }

  List<Widget> buildTeamMemberRow(List<TruncatedProfile> members) {
    Widget addButton = Transform.translate(
        offset: Offset(members.length * 50.0, 0),
        child: Container(
          decoration:
              BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
          height: 60,
          width: 60,
          child: IconButton(
            icon: Icon(FlutterIcons.plus_fea),
            onPressed: () {},
            color: Colors.blueGrey[600],
          ),
        ));
    return (members.isNotEmpty)
        ? [
            Container(
                width: SizeConfig.widthMultiplier * 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        ...members
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
                        addButton
                      ],
                    ),
                  ],
                ))
          ]
        : [
            Row(
              children: [
                addButton,
                SizedBox(width: 10),
                Text("Not Yet Assigned",
                    style: headerText.copyWith(color: Colors.grey[100])),
              ],
            ),
          ];
  }

  Widget _buildAvatar(profile, {double radius = 60}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300], width: 2),
          shape: BoxShape.circle),
      height: radius,
      width: radius,
      child: ClipOval(child: AttachmentImage(profile.profilePhoto)),
    );
  }
}

class SelectStatusPopup extends StatelessWidget {
  const SelectStatusPopup({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ViewTask widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text("Status Column",
              style: TextStyle(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  color: Colors.grey[850])),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            return ListTile(
                title: Text(widget.kanban.taskColumns[index].columnTitle),
                trailing: (widget.kanban.taskColumns[index].columnTitle ==
                        widget.task.taskColumn.columnTitle)
                    ? Icon(
                        Icons.check_circle_outline_rounded,
                        color: kKanbanColor,
                      )
                    : null);
          },
          itemCount: widget.kanban.taskColumns.length,
        ),
      ],
    );
  }
}
