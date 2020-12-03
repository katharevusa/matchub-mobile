import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

class AllocateToTeamMembers extends StatefulWidget {
  Project project;
  PageController controller;
  Map<String, dynamic> additionalPoints;
  Map<String, dynamic> pointsToMembers;
  AllocateToTeamMembers(this.project, this.controller, this.additionalPoints,
      this.pointsToMembers);
  @override
  _AllocateToTeamMembersState createState() => _AllocateToTeamMembersState();
}

class _AllocateToTeamMembersState extends State<AllocateToTeamMembers> {
  num reputationPool;
  @override
  void initState() {
    // reputationPool = widget.project.projectPoolPoints;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    accumulateAdditionalPoints();
    widget.project =
        Provider.of<ManageProject>(context, listen: false).managedProject;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Reward additional point to team members",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            title: Text("Reputation pool: " + reputationPool.toString()),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TeamMemberContribution(widget.project.teamMembers[index],
                  widget.pointsToMembers, accumulateAdditionalPoints);
            },
            itemCount: widget.project.teamMembers.length,
          ),
        ],
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("2/2", style: TextStyle(color: Colors.grey)),
            ),
            RaisedButton(
                color: kSecondaryColor,
                onPressed: () async {
                  await submit();
                  Navigator.pop(context);
                  print(widget.additionalPoints);
                  print(widget.pointsToMembers);
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }

  void accumulateAdditionalPoints() {
    num total = 0;
    widget.pointsToMembers.forEach((k, v) {
      total += v;
    });
    widget.additionalPoints.forEach((k, v) {
      total += v;
    });
    setState(() {
      reputationPool = widget.project.projectPoolPoints - total;
    });
    print(reputationPool);
  }

  submit() async {
    try {
      final url = "authenticated/issuePointsToResourceDonors";
      final response = await ApiBaseHelper.instance.putProtected(url,
          body: json.encode({
            ...widget.additionalPoints,
            "projectId": widget.project.projectId
          }));
      final url1 = "authenticated/issuePointsToTeamMembers";
      final response1 = await ApiBaseHelper.instance.putProtected(url1,
          body: json.encode({
            ...widget.pointsToMembers,
            "projectId": widget.project.projectId
          }));
      print("Success");
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }
}

class TeamMemberContribution extends StatefulWidget {
  Function accumulateAdditionalPoints;
  TruncatedProfile p;
  Map<String, dynamic> pointsToMembers;
  TeamMemberContribution(
      this.p, this.pointsToMembers, this.accumulateAdditionalPoints);

  @override
  _TeamMemberContributionState createState() => _TeamMemberContributionState();
}

class _TeamMemberContributionState extends State<TeamMemberContribution> {
  double spinner = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.p.name,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      trailing: Container(
        child: SpinnerInput(
          spinnerValue:
              widget.pointsToMembers.containsKey(widget.p.accountId.toString())
                  ? widget.pointsToMembers[widget.p.accountId.toString()]
                  : 0,
          minValue: 0,
          onChange: (newValue) {
            setState(() {
              spinner = newValue;
              if (!widget.pointsToMembers
                  .containsKey(widget.p.accountId.toString())) {
                widget.pointsToMembers
                    .putIfAbsent(widget.p.accountId.toString(), () => spinner);
                setState(() {});
              } else {
                widget.pointsToMembers
                    .update(widget.p.accountId.toString(), (value) => spinner);
                setState(() {});
              }
              widget.accumulateAdditionalPoints();
            });
          },
        ),
      ),
    );
  }
}
