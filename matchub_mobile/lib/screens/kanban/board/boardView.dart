library boardview;

import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:core';

import 'boardList.dart';
import 'boardViewController.dart';
import 'columnCreatePopup.dart';

class BoardView2 extends StatefulWidget {
  final List<BoardList> lists;
  final double width;
  Widget middleWidget;
  double bottomPadding;
  bool isSelecting;
  BoardView2Controller boardViewController;

  Function(bool) itemInMiddleWidget;
  OnDropBottomWidget onDropItemInMiddleWidget;
  BoardView2(
      {Key key,
      this.itemInMiddleWidget,
      this.boardViewController,
      this.onDropItemInMiddleWidget,
      this.isSelecting = false,
      this.lists,
      this.width = 280,
      this.middleWidget,
      this.bottomPadding})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BoardView2State();
  }
}

typedef void OnDropBottomWidget(int listIndex, int itemIndex, double percentX);
typedef void OnDropItem(int listIndex, int itemIndex);
typedef void OnDropList(int listIndex);

class BoardView2State extends State<BoardView2> {
  Widget draggedItem;
  int draggedItemIndex;
  int draggedListIndex;
  double dx;
  double dxInit;
  double dyInit;
  double dy;
  double offsetX;
  double offsetY;
  double initialX = 0;
  double initialY = 0;
  double rightListX;
  double leftListX;
  double topListY;
  double bottomListY;
  double topItemY;
  double bottomItemY;
  double height;
  int startListIndex;
  int startItemIndex;

  bool canDrag = true;

  PageController boardViewController =
      new PageController(viewportFraction: 0.88);

  List<BoardListState> listStates = List<BoardListState>();

  OnDropItem onDropItem;
  OnDropList onDropList;

  bool _isInWidget = false;

  var pointer;

  @override
  void initState() {
    super.initState();
    if (widget.boardViewController != null) {
      widget.boardViewController.state = this;
    }
  }

  void moveDown() {
    listStates[draggedListIndex].setState(() {
      topItemY +=
          listStates[draggedListIndex].itemStates[draggedItemIndex + 1].height;
      bottomItemY +=
          listStates[draggedListIndex].itemStates[draggedItemIndex + 1].height;
      var item = widget.lists[draggedListIndex].items[draggedItemIndex];
      widget.lists[draggedListIndex].items.removeAt(draggedItemIndex);
      var itemState = listStates[draggedListIndex].itemStates[draggedItemIndex];
      listStates[draggedListIndex].itemStates.removeAt(draggedItemIndex);
      widget.lists[draggedListIndex].items.insert(++draggedItemIndex, item);
      listStates[draggedListIndex]
          .itemStates
          .insert(draggedItemIndex, itemState);
    });
  }

  void moveUp() {
    listStates[draggedListIndex].setState(() {
      topItemY -=
          listStates[draggedListIndex].itemStates[draggedItemIndex - 1].height;
      bottomItemY -=
          listStates[draggedListIndex].itemStates[draggedItemIndex - 1].height;
      var item = widget.lists[draggedListIndex].items[draggedItemIndex];
      widget.lists[draggedListIndex].items.removeAt(draggedItemIndex);
      var itemState = listStates[draggedListIndex].itemStates[draggedItemIndex];
      listStates[draggedListIndex].itemStates.removeAt(draggedItemIndex);
      widget.lists[draggedListIndex].items.insert(--draggedItemIndex, item);
      listStates[draggedListIndex]
          .itemStates
          .insert(draggedItemIndex, itemState);
    });
  }

  void moveListRight() {
    setState(() {
      var list = widget.lists[draggedListIndex];
      var listState = listStates[draggedListIndex];
      widget.lists.removeAt(draggedListIndex);
      listStates.removeAt(draggedListIndex);
      draggedListIndex++;
      widget.lists.insert(draggedListIndex, list);
      listStates.insert(draggedListIndex, listState);
      canDrag = false;
      if (boardViewController != null && boardViewController.hasClients) {
        int tempListIndex = draggedListIndex;
        boardViewController
            .animateTo(draggedListIndex * widget.width,
                duration: new Duration(milliseconds: 400), curve: Curves.ease)
            .whenComplete(() {
          RenderBox object =
              listStates[tempListIndex].context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          leftListX = pos.dx;
          rightListX = pos.dx + object.size.width;
          Future.delayed(new Duration(milliseconds: 300), () {
            canDrag = true;
          });
        });
      }
    });
  }

  void moveRight() {
    setState(() {
      var item = widget.lists[draggedListIndex].items[draggedItemIndex];
      var itemState = listStates[draggedListIndex].itemStates[draggedItemIndex];
      listStates[draggedListIndex].setState(() {
        widget.lists[draggedListIndex].items.removeAt(draggedItemIndex);
        listStates[draggedListIndex].itemStates.removeAt(draggedItemIndex);
      });
      draggedListIndex++;
      listStates[draggedListIndex].setState(() {
        double closestValue = 10000;
        draggedItemIndex = 0;
        for (int i = 0;
            i < listStates[draggedListIndex].itemStates.length;
            i++) {
          if (listStates[draggedListIndex].itemStates[i].context != null) {
            RenderBox box = listStates[draggedListIndex]
                .itemStates[i]
                .context
                .findRenderObject();
            Offset pos = box.localToGlobal(Offset.zero);
            var temp = (pos.dy - dy + (box.size.height / 2)).abs();
            if (temp < closestValue) {
              closestValue = temp;
              draggedItemIndex = i;
              dyInit = dy;
            }
          }
        }
        widget.lists[draggedListIndex].items.insert(draggedItemIndex, item);
        listStates[draggedListIndex]
            .itemStates
            .insert(draggedItemIndex, itemState);
        canDrag = false;
      });
      if (boardViewController != null && boardViewController.hasClients) {
        int tempListIndex = draggedListIndex;
        int tempItemIndex = draggedItemIndex;
        boardViewController
            .animateTo(draggedListIndex * widget.width,
                duration: new Duration(milliseconds: 400), curve: Curves.ease)
            .whenComplete(() {
          RenderBox object =
              listStates[tempListIndex].context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          leftListX = pos.dx;
          rightListX = pos.dx + object.size.width;
          RenderBox box = listStates[tempListIndex]
              .itemStates[tempItemIndex]
              .context
              .findRenderObject();
          Offset itemPos = box.localToGlobal(Offset.zero);
          topItemY = itemPos.dy;
          bottomItemY = itemPos.dy + box.size.height;
          Future.delayed(new Duration(milliseconds: 300), () {
            canDrag = true;
          });
        });
      }
    });
  }

  void moveListLeft() {
    setState(() {
      var list = widget.lists[draggedListIndex];
      var listState = listStates[draggedListIndex];
      widget.lists.removeAt(draggedListIndex);
      listStates.removeAt(draggedListIndex);
      draggedListIndex--;
      widget.lists.insert(draggedListIndex, list);
      listStates.insert(draggedListIndex, listState);
      canDrag = false;
      if (boardViewController != null && boardViewController.hasClients) {
        int tempListIndex = draggedListIndex;
        boardViewController
            .animateTo(draggedListIndex * widget.width,
                duration: new Duration(milliseconds: 400), curve: Curves.ease)
            .whenComplete(() {
          RenderBox object =
              listStates[tempListIndex].context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          leftListX = pos.dx;
          rightListX = pos.dx + object.size.width;
          Future.delayed(new Duration(milliseconds: 300), () {
            canDrag = true;
          });
        });
      }
    });
  }

  void moveLeft() {
    setState(() {
      var item = widget.lists[draggedListIndex].items[draggedItemIndex];
      var itemState = listStates[draggedListIndex].itemStates[draggedItemIndex];
      listStates[draggedListIndex].setState(() {
        widget.lists[draggedListIndex].items.removeAt(draggedItemIndex);
        listStates[draggedListIndex].itemStates.removeAt(draggedItemIndex);
      });
      draggedListIndex--;
      listStates[draggedListIndex].setState(() {
        double closestValue = 10000;
        draggedItemIndex = 0;
        for (int i = 0;
            i < listStates[draggedListIndex].itemStates.length;
            i++) {
          if (listStates[draggedListIndex].itemStates[i].context != null) {
            RenderBox box = listStates[draggedListIndex]
                .itemStates[i]
                .context
                .findRenderObject();
            Offset pos = box.localToGlobal(Offset.zero);
            var temp = (pos.dy - dy + (box.size.height / 2)).abs();
            if (temp < closestValue) {
              closestValue = temp;
              draggedItemIndex = i;
              dyInit = dy;
            }
          }
        }
        widget.lists[draggedListIndex].items.insert(draggedItemIndex, item);
        listStates[draggedListIndex]
            .itemStates
            .insert(draggedItemIndex, itemState);
        canDrag = false;
      });
      if (boardViewController != null && boardViewController.hasClients) {
        int tempListIndex = draggedListIndex;
        int tempItemIndex = draggedItemIndex;
        boardViewController
            .animateTo(draggedListIndex * widget.width,
                duration: new Duration(milliseconds: 400), curve: Curves.ease)
            .whenComplete(() {
          RenderBox object =
              listStates[tempListIndex].context.findRenderObject();
          Offset pos = object.localToGlobal(Offset.zero);
          leftListX = pos.dx;
          rightListX = pos.dx + object.size.width;
          RenderBox box = listStates[tempListIndex]
              .itemStates[tempItemIndex]
              .context
              .findRenderObject();
          Offset itemPos = box.localToGlobal(Offset.zero);
          topItemY = itemPos.dy;
          bottomItemY = itemPos.dy + box.size.height;
          Future.delayed(new Duration(milliseconds: 300), () {
            canDrag = true;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackWidgets = <Widget>[
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothPageIndicator(
              controller: boardViewController, // PageController
              count: widget.lists.length + 1,
              effect: WormEffect(
                radius: 50,
                dotHeight: 12,
                dotWidth: 12,
                dotColor: Colors.grey[400],
                activeDotColor: Colors.blueGrey[300],
              ),
              onDotClicked: (index) {}),
        ),
        Expanded(child: Container()),
      ]),
      PageView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: widget.lists.length + 1,
        scrollDirection: Axis.horizontal,
        controller: boardViewController,
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.lists.length) {
            return Container(
              width: widget.width,
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              padding: EdgeInsets.fromLTRB(0, 0, 0, widget.bottomPadding ?? 0),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () => showModalBottomSheet(
                          useRootNavigator: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) => ColumnCreatePopup()),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3)),
                        width: 100 * SizeConfig.widthMultiplier,
                        height: 40,
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            Text(
                              "Add Column",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 2 * SizeConfig.textMultiplier),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (widget.lists[index].boardView == null) {
            widget.lists[index] = BoardList(
              title: widget.lists[index].title,
              items: widget.lists[index].items,
              headerBackgroundColor: widget.lists[index].headerBackgroundColor,
              backgroundColor: widget.lists[index].backgroundColor,
              footer: widget.lists[index].footer,
              header: widget.lists[index].header,
              boardView: this,
              draggable: widget.lists[index].draggable,
              onDropList: widget.lists[index].onDropList,
              onTapList: widget.lists[index].onTapList,
              onStartDragList: widget.lists[index].onStartDragList,
            );
          }
          if (widget.lists[index].index != index) {
            widget.lists[index] = BoardList(
              title: widget.lists[index].title,
              items: widget.lists[index].items,
              headerBackgroundColor: widget.lists[index].headerBackgroundColor,
              backgroundColor: widget.lists[index].backgroundColor,
              footer: widget.lists[index].footer,
              header: widget.lists[index].header,
              boardView: this,
              draggable: widget.lists[index].draggable,
              index: index,
              onDropList: widget.lists[index].onDropList,
              onTapList: widget.lists[index].onTapList,
              onStartDragList: widget.lists[index].onStartDragList,
            );
          }

          var temp = Container(
              width: widget.width,
              padding: EdgeInsets.fromLTRB(0, 0, 0, widget.bottomPadding ?? 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[Expanded(child: widget.lists[index])],
              ));
          if (draggedListIndex == index && draggedItemIndex == null) {
            return Opacity(
              opacity: 0.0,
              child: temp,
            );
          } else {
            return temp;
          }
        },
      )
    ];
    bool isInBottomWidget = false;
    if (dy != null) {
      if (MediaQuery.of(context).size.height - dy < 80) {
        isInBottomWidget = true;
      }
    }
    if (widget.itemInMiddleWidget != null && _isInWidget != isInBottomWidget) {
      widget.itemInMiddleWidget(isInBottomWidget);
      _isInWidget = isInBottomWidget;
    }
    if (initialX != null &&
        initialY != null &&
        offsetX != null &&
        offsetY != null &&
        dx != null &&
        dy != null &&
        height != null &&
        widget.width != null) {
      if (canDrag && dxInit != null && dyInit != null && !isInBottomWidget) {
        if (draggedItemIndex != null &&
            draggedItem != null &&
            topItemY != null &&
            bottomItemY != null) {
          //dragging item
          if (0 <= draggedListIndex - 1 && dx < leftListX + 45) {
            //scroll left
            if (boardViewController != null && boardViewController.hasClients) {
              boardViewController.animateTo(
                  boardViewController.position.pixels - 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              RenderBox object =
                  listStates[draggedListIndex].context.findRenderObject();
              Offset pos = object.localToGlobal(Offset.zero);
              leftListX = pos.dx;
              rightListX = pos.dx + object.size.width;
            }
          }
          if (widget.lists.length > draggedListIndex + 1 &&
              dx > rightListX - 45) {
            //scroll right
            if (boardViewController != null && boardViewController.hasClients) {
              boardViewController.animateTo(
                  boardViewController.position.pixels + 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              RenderBox object =
                  listStates[draggedListIndex].context.findRenderObject();
              Offset pos = object.localToGlobal(Offset.zero);
              leftListX = pos.dx;
              rightListX = pos.dx + object.size.width;
            }
          }
          if (0 <= draggedListIndex - 1 && dx < leftListX) {
            //move left
            moveLeft();
          }
          if (widget.lists.length > draggedListIndex + 1 && dx > rightListX) {
            //move right
            moveRight();
          }
          if (dy < topListY + 70) {
            //scroll up
            if (listStates[draggedListIndex].boardListController != null &&
                listStates[draggedListIndex].boardListController.hasClients) {
              listStates[draggedListIndex].boardListController.animateTo(
                  listStates[draggedListIndex]
                          .boardListController
                          .position
                          .pixels -
                      5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              var dif = listStates[draggedListIndex]
                      .boardListController
                      .position
                      .pixels -
                  5;
              if (dif > 5) {
                topItemY += 5;
                bottomItemY += 5;
              } else if (dif > 0) {
                topItemY += dif;
                bottomItemY += dif;
              }
            }
          }
          if (0 <= draggedItemIndex - 1 &&
              dy <
                  topItemY -
                      listStates[draggedListIndex]
                              .itemStates[draggedItemIndex - 1]
                              .height /
                          2) {
            //move up
            moveUp();
          }
          if (dy > bottomListY - 70) {
            //scroll down
            if (listStates[draggedListIndex].boardListController != null &&
                listStates[draggedListIndex].boardListController.hasClients) {
              listStates[draggedListIndex].boardListController.animateTo(
                  listStates[draggedListIndex]
                          .boardListController
                          .position
                          .pixels +
                      5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              var dif = listStates[draggedListIndex]
                      .boardListController
                      .position
                      .maxScrollExtent -
                  listStates[draggedListIndex]
                      .boardListController
                      .position
                      .pixels;
              if (dif > 5) {
                topItemY -= 5;
                bottomItemY -= 5;
              } else if (dif > 0) {
                topItemY -= dif;
                bottomItemY -= dif;
              }
            }
          }
          if (widget.lists[draggedListIndex].items.length >
                  draggedItemIndex + 1 &&
              dy >
                  bottomItemY +
                      listStates[draggedListIndex]
                              .itemStates[draggedItemIndex + 1]
                              .height /
                          2) {
            //move down
            moveDown();
          }
        } else {
          //dragging list
          if (0 <= draggedListIndex - 1 && dx < leftListX + 45) {
            //scroll left
            if (boardViewController != null && boardViewController.hasClients) {
              boardViewController.animateTo(
                  boardViewController.position.pixels - 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              leftListX += 5;
              rightListX += 5;
            }
          }

          if (widget.lists.length > draggedListIndex + 1 &&
              dx > rightListX - 45) {
            //scroll right
            if (boardViewController != null && boardViewController.hasClients) {
              boardViewController.animateTo(
                  boardViewController.position.pixels + 5,
                  duration: new Duration(milliseconds: 10),
                  curve: Curves.ease);
              leftListX -= 5;
              rightListX -= 5;
            }
          }
          if (widget.lists.length > draggedListIndex + 1 && dx > rightListX) {
            //move right
            moveListRight();
          }
          if (0 <= draggedListIndex - 1 && dx < leftListX) {
            //move left
            moveListLeft();
          }
        }
      }
      if (widget.middleWidget != null) {
        stackWidgets.add(widget.middleWidget);
      }
      stackWidgets.add(Positioned(
        width: widget.width,
        height: height,
        child: Opacity(opacity: .7, child: draggedItem),
        left: (dx - offsetX) + initialX,
        top: (dy - offsetY) + initialY,
      ));
    }

    return Container(
        child: Listener(
            onPointerMove: (opm) {
              if (draggedItem != null) {
                setState(() {
                  if (dxInit == null) {
                    dxInit = opm.position.dx;
                  }
                  if (dyInit == null) {
                    dyInit = opm.position.dy;
                  }
                  dx = opm.position.dx;
                  dy = opm.position.dy;
                });
              }
            },
            onPointerDown: (opd) {
              setState(() {
                RenderBox box = context.findRenderObject();
                Offset pos = box.localToGlobal(opd.position);
                offsetX = pos.dx;
                offsetY = pos.dy;
                pointer = opd;
              });
            },
            onPointerUp: (opu) {
              setState(() {
                if (onDropItem != null) {
                  int tempDraggedItemIndex = draggedItemIndex;
                  int tempDraggedListIndex = draggedListIndex;
                  int startDraggedItemIndex = startItemIndex;
                  int startDraggedListIndex = startListIndex;

                  if (_isInWidget && widget.onDropItemInMiddleWidget != null) {
                    onDropItem(startDraggedListIndex, startDraggedItemIndex);
                    widget.onDropItemInMiddleWidget(
                        startDraggedListIndex,
                        startDraggedItemIndex,
                        opu.position.dx / MediaQuery.of(context).size.width);
                  } else {
                    onDropItem(tempDraggedListIndex, tempDraggedItemIndex);
                  }
                }
                if (onDropList != null) {
                  int tempDraggedListIndex = draggedListIndex;
                  if (_isInWidget && widget.onDropItemInMiddleWidget != null) {
                    onDropList(tempDraggedListIndex);
                    widget.onDropItemInMiddleWidget(tempDraggedListIndex, null,
                        opu.position.dx / MediaQuery.of(context).size.width);
                  } else {
                    onDropList(tempDraggedListIndex);
                  }
                }
                draggedItem = null;
                offsetX = null;
                offsetY = null;
                initialX = null;
                initialY = null;
                dx = null;
                dy = null;
                draggedItemIndex = null;
                draggedListIndex = null;
                onDropItem = null;
                onDropList = null;
                dxInit = null;
                dyInit = null;
                leftListX = null;
                rightListX = null;
                topListY = null;
                bottomListY = null;
                topItemY = null;
                bottomItemY = null;
                startListIndex = null;
                startItemIndex = null;
              });
            },
            child: new Stack(
              children: stackWidgets,
            )));
  }

  void run() {
    if (pointer != null) {
      setState(() {
        dx = pointer.position.dx;
        dy = pointer.position.dy;
      });
    }
  }
}
