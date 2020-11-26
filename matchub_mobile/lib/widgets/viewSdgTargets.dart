import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';

class ViewSDGTargets extends StatelessWidget {
  ViewSDGTargets({this.selectedTargets});

  List<SelectedTarget> selectedTargets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Associated SDGs"),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: selectedTargets.length,
            itemBuilder: (_, index) {
              return ExpansionTile(
                title: Text(
                  "Goal ${selectedTargets[index].sdg.sdgId}:  ${selectedTargets[index].sdg.sdgName}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[850],),
                ),
                children: [
                  ListView.separated(
                    separatorBuilder: (_, __) =>
                        Divider(thickness: 0, height: 4),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: selectedTargets[index].sdgTargets.length,
                    itemBuilder: (__, idx) => ListTile(
                      title: Text(
                        "${selectedTargets[index].sdgTargets[idx].sdgTargetNumbering}.  ${selectedTargets[index].sdgTargets[idx].sdgTargetDescription}",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[850],
                            fontFamily: "Lato",
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              );
            }));
  }
}
