import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/helpers/extensions.dart';

import 'createLabel.dart';

class SelectTagsDialog extends StatefulWidget {
  SelectTagsDialog({
    Key key,
    @required this.kanbanController,
    // @required this.task,
  }) : super(key: key);

  // final TaskEntity task;
  final KanbanController kanbanController;

  @override
  _SelectTagsDialogState createState() => _SelectTagsDialogState();
}

class _SelectTagsDialogState extends State<SelectTagsDialog> {
  initState() {
    filteredLabels.addAll(widget.kanbanController.labels);
  }

  Map<String, dynamic> selectedLabels = {};  //label name, colo
  Map<String, dynamic> filteredLabels = {};

  filterLabels(String searchQuery) {
    filteredLabels.clear();
    filteredLabels.addAll(widget.kanbanController.labels);
    filteredLabels.removeWhere(
        (key, value) => !key.toLowerCase().contains(searchQuery.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    print(selectedLabels);
    return Stack(children: [
      Container(
        height: SizeConfig.heightMultiplier * 50,
        width: SizeConfig.widthMultiplier * 80,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 20, right: 20, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Choose Label",
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 2.4 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w700)),
                FlatButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (_) => CreateLabel()))
                        .then((value) {
                      setState(() {
                        filterLabels("");
                      });
                    });
                  },
                  child: Row(children: [Icon(Icons.add), Text("Add")]),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
                initialValue: "",
                onChanged: (value) {
                  filterLabels(value.trim());
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                    isCollapsed: true,
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey[700]))),
          ),
          Scrollbar(
              radius: Radius.circular(5),
              child: Column(children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredLabels.length,
                    itemBuilder: (context, index) {
                      MapEntry label = filteredLabels.entries.toList()[index];
                      bool hasLabel = selectedLabels.containsKey(label.key);
                      return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          onTap: () {
                            setState(() {
                              if (!selectedLabels.containsKey(label.key)) {
                                selectedLabels.addEntries([label]);
                              } else {
                                selectedLabels.remove(label.key);
                              }
                            });
                          },
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          leading: TaskLabel(label: label),
                          trailing: hasLabel
                              ? Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: kKanbanColor,
                                )
                              : null);
                    }),
                if (filteredLabels.isEmpty) ...[
                  SizedBox(height: 20),
                  Container(
                    height: 160,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/nolabel.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ]
              ])),
        ]),
      ),
      Positioned(
        bottom: 20,
        right: 5 * SizeConfig.widthMultiplier,
        left: 5 * SizeConfig.widthMultiplier,
        child: FlatButton(
          color: kKanbanColor,
          onPressed: () => Navigator.pop(context, selectedLabels),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 60 * SizeConfig.widthMultiplier,
              child: Text(
                "Confirm",
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

class TaskLabel extends StatelessWidget {
  const TaskLabel({
    Key key,
    @required this.label,
  }) : super(key: key);

  final MapEntry label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
            color: (label.value as String).hexToColor.withAlpha(100),
            borderRadius: BorderRadius.circular(5)),
        child: Text(label.key,
            style: TextStyle(
                fontSize: 1.8 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
