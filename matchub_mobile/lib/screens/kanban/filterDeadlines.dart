import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/kanban/task/viewTask.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class SelectDeadline extends StatefulWidget {
  const SelectDeadline({
    Key key,
    @required this.filterOptions,
  }) : super(key: key);

  final Map<String, dynamic> filterOptions;

  @override
  _SelectDeadlineState createState() => _SelectDeadlineState();
}

class _SelectDeadlineState extends State<SelectDeadline> {
  removeFilters({String retainFilter}) {
    bool val;
    if (retainFilter != null) {
      val = widget.filterOptions['deadlines'][retainFilter];
    }
    widget.filterOptions['deadlines'].updateAll((key, value) => value = false);
    if (retainFilter != null) {
      widget.filterOptions['deadlines'][retainFilter] = val;
    }
    print(widget.filterOptions['deadlines']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text("Filter by",
              style: TextStyle(
                  fontSize: 2.4 * SizeConfig.textMultiplier,
                  color: Colors.grey[850])),
        ),
        Theme(
          data: ThemeData(accentColor: kKanbanColor),
          child: ListView(shrinkWrap: true, children: [
            RadioListTile<bool>(
              selected: widget.filterOptions['none'],
              groupValue: true,
              value: widget.filterOptions['none'],
              onChanged: (bool value) {
                setState(() {
                  widget.filterOptions['none'] = !widget.filterOptions['none'];
                  removeFilters();
                });
              },
              title: Text("None"),
            ),
            RadioListTile<bool>(
              selected: widget.filterOptions['deadlines']['showMyTasks'],
              groupValue: true,
              // toggleable: true,
              value: widget.filterOptions['deadlines']['showMyTasks'],
              onChanged: (bool value) {
                setState(() {
                  widget.filterOptions['deadlines']['showMyTasks'] =
                      !widget.filterOptions['deadlines']['showMyTasks'];
                  widget.filterOptions['none'] = false;
                  removeFilters(retainFilter: "showMyTasks");
                });
              },
              title: Text("Just my reporting tasks"),
            ),
            RadioListTile<bool>(
              selected: widget.filterOptions['deadlines']['thisWeek'],
              groupValue: true,
              // toggleable: true,
              value: widget.filterOptions['deadlines']['thisWeek'],
              onChanged: (bool value) {
                setState(() {
                  widget.filterOptions['deadlines']['thisWeek'] =
                      !widget.filterOptions['deadlines']['thisWeek'];
                  widget.filterOptions['none'] = false;
                  removeFilters(retainFilter: "thisWeek");
                });
              },
              title: Text("Due this week"),
            ),
            RadioListTile<bool>(
              selected: widget.filterOptions['deadlines']['nextWeek'],
              groupValue: true,
              // toggleable: true,
              value: widget.filterOptions['deadlines']['nextWeek'],
              onChanged: (bool value) {
                setState(() {
                  widget.filterOptions['deadlines']['nextWeek'] =
                      !widget.filterOptions['deadlines']['nextWeek'];
                  widget.filterOptions['none'] = false;
                  removeFilters(retainFilter: "nextWeek");
                });
              },
              title: Text("Due next week"),
            ),
          ]),
        ),
      ],
    );
  }
}
