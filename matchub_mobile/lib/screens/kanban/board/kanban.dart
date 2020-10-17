import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:provider/provider.dart';

import 'boardItem.dart';
import 'boardList.dart';
import 'boardView.dart';
import 'boardViewController.dart';

class KanbanView extends StatefulWidget {
  @override
  _KanbanViewState createState() => _KanbanViewState();
}

class _KanbanViewState extends State<KanbanView> {
  List<BoardListObject> _listData = [
    BoardListObject(title: "List title 1"),
    BoardListObject(title: "List title 2"),
    BoardListObject(title: "List title 3")
  ];

  BoardView2Controller boardViewController = new BoardView2Controller();

  @override
  Widget build(BuildContext context) {
    List<BoardList> _lists = List<BoardList>();
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i]));
    }
    return ChangeNotifierProvider(
      create: (_) =>
          KanbanController(),
      child: Consumer<KanbanController>(
        builder: (context, search, child) => Scaffold(
        appBar: AppBar(title: Text("My Frirst Kanban")),
        backgroundColor: Color.fromARGB(255, 235, 236, 240),
        body: BoardView2(
          lists: _lists,
          boardViewController: boardViewController,
          width: 80 * SizeConfig.widthMultiplier,
        ),
      
    )));
  }

  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
        onStartDragItem:
            (int listIndex, int itemIndex, BoardItemState state) {},
        onDropItem: (int listIndex, int itemIndex, int oldListIndex,
            int oldItemIndex, BoardItemState state) {
          //Used to update our local item data
          var item = _listData[oldListIndex].items[oldItemIndex];
          _listData[oldListIndex].items.removeAt(oldItemIndex);
          _listData[listIndex].items.insert(itemIndex, item);
          print(item);
        },
        onTapItem:
            (int listIndex, int itemIndex, BoardItemState state) async {},
        item: Container(
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemObject.title),
          ),
        ));
  }

  Widget _createBoardList(BoardListObject list) {
    List<BoardItem> items = new List();
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(list.items[i]));
    }

    return BoardList(
      onStartDragList: (int listIndex) {},
      onTapList: (int listIndex) async {},
      onDropList: (int listIndex, int oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex, list);
        print(items.map((e) => e.item).toString());
      },
      backgroundColor: Colors.transparent,
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.title,
                  style: TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );
  }
}

class BoardItemObject extends StatefulWidget {
  String title;
  BoardItemObject({this.title});

  @override
  _BoardItemObjectState createState() => _BoardItemObjectState();
}

class _BoardItemObjectState extends State<BoardItemObject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Center(
        child: Text(widget.title),
      ),
    );
  }
}

class BoardListObject extends StatefulWidget {
  String title;
  List<BoardItemObject> items = [
    BoardItemObject(
      title: "First Item",
    ),
    BoardItemObject(
      title: "Second Item",
    ),
    BoardItemObject(
      title: "Third Item",
    )
  ];
  BoardListObject({this.title});

  @override
  _BoardListObjectState createState() => _BoardListObjectState();
}

class _BoardListObjectState extends State<BoardListObject> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(height: 500, child: Text(widget.title)),
          Container(height: 500, child: Text(widget.title)),
          Container(height: 500, child: Text(widget.title)),
        ],
      ),
    );
  }
}
