import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/helpers/sdgs.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/selectableAppBar.dart';
import 'package:matchub_mobile/widgets/selectableWidget.dart';

class SDGPicker extends StatefulWidget {
  static const routeName = "/sdg-picker";

  @override
  _SDGPickerState createState() => _SDGPickerState();
}

class _SDGPickerState extends State<SDGPicker> {
  final controller = DragSelectGridViewController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SelectionAppBar(
        selection: controller.value,
        title: Text("Press & Hold to Select your SDGs",
            style: TextStyle(fontSize: 18)),
        function: FlatButton(
          padding: EdgeInsets.all(0),
          visualDensity: VisualDensity.compact,
          color: kPrimaryColor,
          onPressed: () => Navigator.pop(context, controller.value.selectedIndexes.toList()),
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
      body: DragSelectGridView(
        gridController: controller,
        itemCount: sdgs.length,
        itemBuilder: (context, index, selected) {
          return SelectableItem(
            index: index,
            selected: selected,
          );
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          // mainAxisSpacing: 10,
          // crossAxisSpacing: 10,
          maxCrossAxisExtent: 160,
        ),
      ),
    );
  }

  void scheduleRebuild() => setState(() {});
}
