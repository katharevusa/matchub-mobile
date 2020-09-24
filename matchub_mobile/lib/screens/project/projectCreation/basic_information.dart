import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';

class Basic_information extends StatefulWidget {
  Map<String, dynamic> project;
  Basic_information(this.project);

  @override
  _Basic_informationState createState() => _Basic_informationState();
}

class _Basic_informationState extends State<Basic_information> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();
    _titleController.text = widget.project["projectTitle"];
    _descriptionController.text = widget.project["projectDescription"];
    widget.project["country"] = "Singapore";
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(hintText: 'Title'),
                controller: _titleController,
                // autofocus: true,
                onChanged: (text) {
                  if (text != null) {
                    widget.project["projectTitle"] = text;
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(hintText: 'Description'),
                controller: _descriptionController,
                autofocus: true,
                onChanged: (text) {
                  widget.project["projectDescription"] = text;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Select country",
                    style: TextStyle(fontSize: 17),
                  ),
                  CountryListPick(
                      isShowFlag: true,
                      isShowTitle: true,
                      isDownIcon: true,
                      showEnglishName: true,
                      initialSelection: '+65',
                      buttonColor: Colors.transparent,
                      onChanged: (CountryCode code) {
                        widget.project["country"] = code.name;
                      }),
                ],
              ),
            )
          ],
        )));
  }
}
