import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/style.dart';

class SdgTargetSelectScreen extends StatefulWidget {
  static const routeName = "/select-targets";
  List selectedSdgs;
  Map sdgMap;
  SdgTargetSelectScreen(this.selectedSdgs, this.sdgMap);

  @override
  _SdgTargetSelectScreenState createState() => _SdgTargetSelectScreenState();
}

class _SdgTargetSelectScreenState extends State<SdgTargetSelectScreen> {
  Future sdgFuture;
  List<Sdg> allSdgs = List<Sdg>();
  Map<num, dynamic> selectedTargets = {};

  @override
  void initState() {
    print(widget.sdgMap);
    selectedTargets = Map.from(widget.sdgMap);
    print(selectedTargets);
    sdgFuture = retrieveAllSDGs();
    super.initState();
  }

  retrieveAllSDGs() async {
    final responseData =
        await ApiBaseHelper.instance.getProtected("authenticated/getAllSdgs");
    allSdgs =
        (responseData['content'] as List).map((e) => Sdg.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select your SDG Targets"),
        actions: [
          FlatButton(
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            color: kPrimaryColor,
            onPressed: () => Navigator.pop(context, selectedTargets),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: sdgFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());

          List<Sdg> chosenSdg = [];
          print("Selected SDGs Ids:" + widget.selectedSdgs.toString());
          for (var sdg in widget.selectedSdgs) {
            chosenSdg.add(allSdgs[sdg - 1]);
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: chosenSdg.length,
            itemBuilder: (ctx, index) => Theme(
              data: ThemeData(accentColor: Colors.blueGrey[400]),
              child: ExpansionTile(
                leading: Checkbox(
                    value: selectedTargets.containsKey(chosenSdg[index].sdgId),
                    onChanged: (select) {
                      if (select) {
                        selectedTargets.putIfAbsent(
                            chosenSdg[index].sdgId,
                            () => chosenSdg[index]
                                .targets
                                .map((e) => e.sdgTargetId)
                                .toList());
                      } else {
                        selectedTargets.remove(chosenSdg[index].sdgId);
                      }
                      setState(() {});
                    }),
                title: Text(
                    "Goal ${chosenSdg[index].sdgId}: ${chosenSdg[index].sdgName}"),
                children: [
                  ListView.separated(
                      separatorBuilder: (_, __) =>
                          Divider(thickness: 0, height: 4),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chosenSdg[index].targets.length,
                      itemBuilder: (_, idx) {
                        bool value = true;
                        if (!selectedTargets
                                .containsKey(chosenSdg[index].sdgId) ||
                            !selectedTargets[chosenSdg[index].sdgId].contains(
                                chosenSdg[index].targets[idx].sdgTargetId)) {
                          value = false;
                        }
                        return CheckboxListTile(
                          activeColor: AppTheme.projectPink,
                          value: value,
                          onChanged: (select) {
                            if (select) {
                              selectedTargets.update(
                                chosenSdg[index].sdgId,
                                (value) {
                                  List updated = value;
                                  updated.add(chosenSdg[index]
                                      .targets[idx]
                                      .sdgTargetId);
                                  return updated;
                                },
                                ifAbsent: () =>
                                    [chosenSdg[index].targets[idx].sdgTargetId],
                              );
                            } else {
                              selectedTargets.update(
                                chosenSdg[index].sdgId,
                                (value) {
                                  List updated = value;
                                  updated.removeWhere((e) =>
                                      e ==
                                      chosenSdg[index]
                                          .targets[idx]
                                          .sdgTargetId);
                                  return updated;
                                },
                                ifAbsent: () =>
                                    [chosenSdg[index].targets[idx].sdgTargetId],
                              );
                            }
                            setState(() {});
                          },
                          title: Text(
                              "${chosenSdg[index].targets[idx].sdgTargetNumbering}  ${chosenSdg[index].targets[idx].sdgTargetDescription}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[850],
                                  fontWeight: FontWeight.w400)),
                        );
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
