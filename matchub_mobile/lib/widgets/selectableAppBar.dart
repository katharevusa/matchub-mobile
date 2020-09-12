import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SelectionAppBar({
    Key key,
    this.title,
    this.function,
    this.selection = const Selection.empty(),
  })  : assert(selection != null),
        super(key: key);

  final Widget title;
  final Selection selection;
  final Widget function;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: selection.isSelecting
          ? AppBar(
              key: const Key('selecting'),
              titleSpacing: 0,
              leading: const CloseButton(),
              title: Text('${selection.amount} SDG(s) selected…'),
              actions: [function],
            )
          : AppBar(
              key: const Key('not-selecting'),
              title: title,
              // actions: [function]
            ),
    );
  }
}