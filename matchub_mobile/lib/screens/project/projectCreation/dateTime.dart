import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../sizeconfig.dart';

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
          // Container(
          //   height: 300,
          //   child: CupertinoDatePicker(
          //     mode: CupertinoDatePickerMode.dateAndTime,
          //     minimumDate: (widget.project['projectId'] == null) ? DateTime.now().subtract(Duration(minutes: 30)) : null,
          //     initialDateTime: widget.project["startDate"],
          //     onDateTimeChanged: (newDateTime) {
          //       setState(() {
          //         widget.project["startDate"] = newDateTime;
          //         print(widget.project["startDate"]);
          //       });
          //     },
          //   ),
          // ),
          DateTimePicker(
            type: DateTimePickerType.dateTime,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelText: 'Start Date',
              labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 1.6 * SizeConfig.textMultiplier),
            ),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            style: TextStyle(
                color: Colors.black, fontSize: 1.6 * SizeConfig.textMultiplier),
            onChanged: (val) {
              widget.project["startDate"] = DateTime.parse(val);
              setState(() {});
            },
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTime,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelText: 'End Date time',
              labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 1.6 * SizeConfig.textMultiplier),
            ),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            style: TextStyle(
                color: Colors.black, fontSize: 1.6 * SizeConfig.textMultiplier),
            onChanged: (val) {
              widget.project["endDate"] = DateTime.parse(val);
              setState(() {});
            },
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
