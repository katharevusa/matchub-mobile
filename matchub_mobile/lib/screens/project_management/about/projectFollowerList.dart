import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class ProjectFollowerList extends StatefulWidget {
  Project project;
  ProjectFollowerList({this.project});
  @override
  _ProjectFollowerListState createState() => _ProjectFollowerListState();
}

class _ProjectFollowerListState extends State<ProjectFollowerList> {
  @override
  Widget build(BuildContext context) {
    widget.project = Provider.of<ManageProject>(context).managedProject;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kScaffoldColor,
          elevation: 0,
          title:
              Text("Project followers", style: TextStyle(color: Colors.black)),
          // automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: widget.project.projectFollowers[index]
                            .profilePhoto.isEmpty
                        ? AssetImage("assets/images/avatar2.jpg")
                        : NetworkImage(
                            "${ApiBaseHelper.instance.baseUrl}${widget.project.projectFollowers[index].profilePhoto.substring(30)}"),
                  ),
                  title: Text(widget.project.projectFollowers[index].name,
                      style: TextStyle(
                        color: Colors.grey[850],
                      )));
            },
            itemCount: widget.project.projectFollowers.length));
  }
}
