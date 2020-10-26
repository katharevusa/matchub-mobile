import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/kanban/task/viewTask.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class SelectStatusPopup extends StatefulWidget {
  const SelectStatusPopup({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ViewTask widget;

  @override
  _SelectStatusPopupState createState() => _SelectStatusPopupState();
}

class _SelectStatusPopupState extends State<SelectStatusPopup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text("Status Column",
              style: TextStyle(
                  fontSize: 2.4 * SizeConfig.textMultiplier,
                  color: Colors.grey[850])),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            return ListTile(
                onTap: () async {
                  if (widget.widget.kanban.taskColumns[index].columnTitle !=
                      widget.widget.task.taskColumn.columnTitle) {
                    var instance =
                        Provider.of<KanbanController>(context, listen: false);

                    instance.reorderTaskSequenceInTaskView(
                        widget.widget.kanban.taskColumns.firstWhere((element) =>
                            element.columnTitle ==
                            widget.widget.task.taskColumn.columnTitle),
                        widget.widget.kanban.taskColumns[index],
                        widget.widget.task);
                    // await instance.reorderTaskSequence(
                    //     Provider.of<Auth>(context, listen: false)
                    //         .myProfile
                    //         .accountId);
                  }
                  setState(() {});
                },
                title:
                    Text(widget.widget.kanban.taskColumns[index].columnTitle),
                trailing:
                    (widget.widget.kanban.taskColumns[index].columnTitle ==
                            widget.widget.task.taskColumn.columnTitle)
                        ? Icon(
                            Icons.check_circle_outline_rounded,
                            color: kKanbanColor,
                          )
                        : null);
          },
          itemCount: widget.widget.kanban.taskColumns.length,
        ),
      ],
    );
  }
}
