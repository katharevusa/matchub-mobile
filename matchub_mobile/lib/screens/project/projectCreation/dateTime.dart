import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Start extends StatefulWidget {
  Map<String, dynamic> project;
  Start(this.project);
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            DateFormat.yMMMd().add_jm().format(widget.project['startDate']),
          ),
          Container(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              minimumDate: DateTime.now().subtract(Duration(minutes: 30)),
              initialDateTime: widget.project["startDate"],
              onDateTimeChanged: (newDateTime) {
                setState(() {
                  widget.project["startDate"] = newDateTime;
                  print(widget.project["startDate"]);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class End extends StatefulWidget {
  Map<String, dynamic> project;
  End(this.project);
  @override
  _EndState createState() => _EndState();
}

class _EndState extends State<End> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            DateFormat.yMMMd().add_jm().format(widget.project['endDate']),
          ),
          Container(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              initialDateTime:
                  widget.project['startDate'].add(Duration(minutes: 10)),
              minimumDate: widget.project['startDate'],
              onDateTimeChanged: (newDateTime) {
                setState(() {
                  widget.project["endDate"] = newDateTime;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
