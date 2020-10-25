import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class SelectTaskMembers extends StatefulWidget {
  SelectTaskMembers({
    Key key,
    @required this.kanbanController,
    @required this.listOfTaskDoers,
  }) : super(key: key);

  final List listOfTaskDoers;
  final KanbanController kanbanController;

  @override
  _SelectTaskMembersState createState() => _SelectTaskMembersState();
}

class _SelectTaskMembersState extends State<SelectTaskMembers> {
  List<Profile> selectedTaskMembers = [];

  @override
  initState() {
    widget.listOfTaskDoers.forEach((taskDoer) {
      int idx = widget.kanbanController.channelMembers.indexWhere(
          (channelMember) => channelMember.accountId == taskDoer.accountId);
      if (idx >= 0) {
        selectedTaskMembers.add(widget.kanbanController.channelMembers[idx]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(selectedTaskMembers.map((e) => e.accountId));
    return Stack(children: [
      Container(
        height: SizeConfig.heightMultiplier * 50,
        width: SizeConfig.widthMultiplier * 80,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20, right: 20, bottom: 10),
            child: Text(
                "Channel Members - ${widget.kanbanController.channelMembers.length.toString()}",
                style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 2.2 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w700)),
          ),
          Scrollbar(
            radius: Radius.circular(5),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.kanbanController.channelMembers.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  if (selectedTaskMembers.indexWhere((selectedMember) =>
                          selectedMember.accountId ==
                          widget.kanbanController.channelMembers[index]
                              .accountId) >=
                      0) {
                    selectedTaskMembers
                        .remove(widget.kanbanController.channelMembers[index]);
                  } else {
                    selectedTaskMembers
                        .add(widget.kanbanController.channelMembers[index]);
                  }
                  setState(() {
                    print(selectedTaskMembers.map((e) => e.accountId));
                  });
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedTaskMembers.contains(
                                  widget.kanbanController.channelMembers[index])
                              ? kKanbanColor
                              : Colors.grey[300],
                          width: 3),
                      shape: BoxShape.circle),
                  height: 50,
                  width: 50,
                  child: ClipOval(
                      child: AttachmentImage(widget.kanbanController
                          .channelMembers[index].profilePhoto)),
                ),
                title: Text(widget.kanbanController.channelMembers[index].name,
                    style: TextStyle(
                        color: selectedTaskMembers.contains(
                                widget.kanbanController.channelMembers[index])
                            ? kKanbanColor
                            : Colors.grey[900],
                        fontSize: 1.8 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ]),
      ),
      Positioned(
        bottom: 20,
        right: 5 * SizeConfig.widthMultiplier,
        left: 5 * SizeConfig.widthMultiplier,
        child: FlatButton(
          color: kKanbanColor,
          onPressed: () => Navigator.pop(context, selectedTaskMembers),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 60 * SizeConfig.widthMultiplier,
              child: Text(
                "Assign",
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
