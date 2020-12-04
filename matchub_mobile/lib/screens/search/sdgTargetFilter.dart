import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/style.dart';

class SdgTargetFilterScreen extends StatefulWidget {
  static const routeName = "/select-targets";
  List sdgs;
  List sdgTargets;
  SdgTargetFilterScreen(this.sdgs, this.sdgTargets);

  @override
  _SdgTargetFilterScreenState createState() => _SdgTargetFilterScreenState();
}

class _SdgTargetFilterScreenState extends State<SdgTargetFilterScreen> {
  Future sdgFuture;
  List<Sdg> allSdgs = List<Sdg>();
  List selectedTargetIds = [];
  List selectedSdgIds = [];

  @override
  void initState() {
    selectedTargetIds = widget.sdgTargets;
    selectedSdgIds = widget.sdgs;
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
        title: Text("Filter by SDG(s)"),
        actions: [
          FlatButton(
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            color: kPrimaryColor,
            onPressed: () => Navigator.pop(context,
                {"sdgs": selectedSdgIds, "sdgTargetIds": selectedTargetIds}),
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

          // List<Sdg> chosenSdg = [];
          // for (var sdg in widget.selectedSdgs) {
          //   chosenSdg.add(allSdgs[sdg - 1]);
          // }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: allSdgs.length,
            itemBuilder: (ctx, index) => Theme(
              data: ThemeData(accentColor: Colors.blueGrey[400]),
              child: ExpansionTile(
                leading: Checkbox(
                    value: selectedSdgIds.contains(allSdgs[index].sdgId),
                    onChanged: (select) {
                      List targetsOfSdg = allSdgs[index]
                          .targets
                          .map((e) => e.sdgTargetId)
                          .toList();
                      if (select) {
                        selectedSdgIds.add(allSdgs[index].sdgId);
                        selectedTargetIds.addAll(targetsOfSdg);
                      } else {
                        selectedSdgIds.remove(allSdgs[index].sdgId);
                        selectedTargetIds
                            .removeWhere((e) => targetsOfSdg.contains(e));
                      }
                      selectedSdgIds.toSet();
                      selectedTargetIds.toSet();
                      selectedSdgIds.sort((a, b) => a.compareTo(b));
                      selectedTargetIds.sort((a, b) => a.compareTo(b));
                      print(selectedSdgIds);
                      print(selectedTargetIds);
                      setState(() {});
                    }),
                title: Text(
                    "Goal ${allSdgs[index].sdgId}: ${allSdgs[index].sdgName}"),
                children: [
                  ListView.separated(
                      separatorBuilder: (_, __) =>
                          Divider(thickness: 0, height: 4),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: allSdgs[index].targets.length,
                      itemBuilder: (_, idx) {
                        bool value = true;
                        if (!selectedTargetIds.contains(
                            allSdgs[index].targets[idx].sdgTargetId)) {
                          value = false;
                        }
                        return CheckboxListTile(
                          activeColor: AppTheme.projectPink,
                          value: value,
                          onChanged: (select) {
                            if (select) {
                              selectedTargetIds
                                  .add(allSdgs[index].targets[idx].sdgTargetId);
                              if (!selectedSdgIds
                                  .contains(allSdgs[index].sdgId)) {
                                selectedSdgIds.add(allSdgs[index].sdgId);
                              }
                            } else {
                              selectedTargetIds.remove(
                                  allSdgs[index].targets[idx].sdgTargetId);
                            }
                            selectedSdgIds.toSet();
                            selectedTargetIds.toSet();
                            selectedSdgIds.sort((a, b) => a.compareTo(b));
                            selectedTargetIds.sort((a, b) => a.compareTo(b));
                            print(selectedSdgIds);
                            print(selectedTargetIds);
                            setState(() {});
                          },
                          title: Text(
                              "${allSdgs[index].targets[idx].sdgTargetNumbering}  ${allSdgs[index].targets[idx].sdgTargetDescription}",
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
