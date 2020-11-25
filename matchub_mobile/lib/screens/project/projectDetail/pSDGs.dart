import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/viewSdgTargets.dart';
import 'package:provider/provider.dart';

class PSdgTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Project project = Provider.of<ManageProject>(context).managedProject;

    return Container(
      height: 40,
      child: ListView(
          physics: BouncingScrollPhysics(),
          primary: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            Tags(
              itemCount: project.sdgs.length, // required
              itemBuilder: (int index) {
                return ItemTags(
                  key: Key(index.toString() + project.sdgs[index].toString()),
                  index: index, // required
                  title: project.sdgs[index].sdgName,
                  color: Color(0xFFFFe49D),
                  activeColor: Color(0xFFFFe49D),
                  // border: Border.all(color: Colors.grey[400]),
                  textColor: Colors.grey[850],
                  textActiveColor: Colors.grey[850],
                  elevation: 3,
                  active: false,
                  pressEnabled: true,
                  onPressed: (_) => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => ViewSDGTargets(
                              selectedTargets: project.selectedTargets))),
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 12.0),
                );
              },
              alignment: WrapAlignment.end,
              runAlignment: WrapAlignment.start,
              spacing: 6,
              runSpacing: 6,
            ),
          ]),
    );
  }
}
