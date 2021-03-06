import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/user/selectTargets.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';

class SDG extends StatefulWidget {
  Map<String, dynamic> project;
  SDG(this.project);

  @override
  _SDGState createState() => _SDGState();
}

class _SDGState extends State<SDG> {
  @override
  Widget build(BuildContext context) {
    List targets = [];
    widget.project['hashmapSDG'].forEach((k, v) => targets.addAll(v));
    print(widget.project['sdgs']);
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(SDGPicker.routeName)
                    .then((value) {
                  setState(() {
                    if (value != null) {
                      var list = [];
                      widget.project['sdgs'] = value;
                      widget.project['sdgs'].forEach((e) => list.add(e + 1));
                      print(list);
                      widget.project['sdgs'] = list;
                      widget.project['hashmapSDG'].clear();
                      widget.project['sdgs'].forEach((e) => widget
                          .project['hashmapSDG']
                          .putIfAbsent(e, () => []));
                    }
                    print(widget.project['sdgs']);
                  });
                });
              },
              child: Container(
                constraints: BoxConstraints(
                    minHeight: 7.5 * SizeConfig.heightMultiplier),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.grey[850]),
                    )),
                child: Center(
                    child: Column(
                  children: [
                    Text("Select your SDG(s)", style: AppTheme.titleLight),
                    if (widget.project['sdgs'] != null) ...[
                      SizedBox(height: 5),
                      Text(
                        "${widget.project['sdgs'].length} SDG(s) chosen",
                      ),
                      SizedBox(height: 5),
                      GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  // mainAxisSpacing: 10,
                                  // crossAxisSpacing: 10,
                                  childAspectRatio: 1,
                                  crossAxisCount: 3),
                          itemCount: widget.project['sdgs'].length,
                          itemBuilder: (BuildContext context, int index) {
                            int i = (widget.project['sdgs'][index]);
                            // i++;
                            return Container(
                              // height:50,
                              child: Image.asset("assets/icons/goal$i.png"),
                            );
                          }),
                    ],
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (_) => SdgTargetSelectScreen(
                                    widget.project['sdgs'],
                                    widget.project['hashmapSDG'])))
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              // widget.project['sdgIds'] = widget.project['hashmapSDG'].keys.toList();
                              widget.project['hashmapSDG'] = value;
                              (widget.project['sdgs'] as List)
                                  .forEach((element) {
                                widget.project['hashmapSDG']
                                    .putIfAbsent(element, () => []);
                              });
                            });
                          }
                        });
                      },
                      child: Container(
                          constraints: BoxConstraints(
                              minHeight: 7.5 * SizeConfig.heightMultiplier),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.fromBorderSide(
                                BorderSide(
                                    color: Colors.grey[850].withOpacity(0.1)),
                              )),
                          child: Center(
                              child: Text(
                                  "You've selected ${targets.length} targets"))),
                    ),
                  ],
                )),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
