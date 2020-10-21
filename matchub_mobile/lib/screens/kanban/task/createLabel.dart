import 'package:flutter/material.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class CreateLabel extends StatefulWidget {
  @override
  _CreateLabelState createState() => _CreateLabelState();
}

class _CreateLabelState extends State<CreateLabel> {
  String labelName;
  String selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Create New Label",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white)),
            actions: [
              FlatButton(
                padding: EdgeInsets.all(0),
                visualDensity: VisualDensity.compact,
                color: kPrimaryColor,
                onPressed: () {
                  if (labelName != null &&
                      labelName.isNotEmpty &&
                      selectedColor != null) {
                    Provider.of<KanbanController>(context)
                        .labels
                        .addAll({labelName: selectedColor});
                  }
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              )
            ]),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  initialValue: "",
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      labelName = value.trim();
                    }
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[850],
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[850],
                        ),
                      ),
                      hintText: "Label Name",
                      hintStyle: TextStyle(color: Colors.grey[700]))),
            ),
            ListView.separated(
                separatorBuilder: (_, __) => Divider(
                      height: 4,
                    ),
                shrinkWrap: true,
                itemCount: availableColors.length,
                itemBuilder: (_, index) {
                  MapEntry<String, String> label =
                      availableColors.entries.toList()[index];
                  // bool hasLabel = selectedLabels.containsKey(label.key);
                  return ListTile(
                    dense: true,
                    leading: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: (label.value as String)
                              .hexToColor
                              .withAlpha(100)),
                      height: 24,
                      width: 24,
                      child: Center(),
                    ),
                    title: Text(label.key, style: TextStyle(fontSize: 14)),
                    trailing:
                        (selectedColor != null && selectedColor == label.value)
                            ? Icon(
                                Icons.check_circle_outline_rounded,
                                color: kKanbanColor,
                              )
                            : null,
                    onTap: () => setState(() {
                      selectedColor = label.value;
                    }),
                  );
                })
          ]),
        ));
  }
}

const Map<String, String> availableColors = {
  "red": "#d11141",
  "blue": "#00aedb",
  "green": "#00b159",
  "orange": "#f37735",
  // "yellow": " #ffc422",
  "pink": "#b100a2",
  "purple": "#3b00b1",
  "indigo": "#001bb1",
  "brown": "#4f372d",
  "grey": "#c2c2c2"
};
