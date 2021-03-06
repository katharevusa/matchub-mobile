import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/reputationPointAllocation/allocateToTeamMembers.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import 'allocateToResourceDonors.dart';

class RepAllocation extends StatelessWidget {
  Project project;
  RepAllocation(this.project);
  @override
  Widget build(BuildContext context) {
    project = Provider.of<ManageProject>(context, listen: false).managedProject;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            settings: RouteSettings(name: ""),
            builder: (_) => Allocation(project)));
      },
      child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: 4 * SizeConfig.widthMultiplier),
          height: 5 * SizeConfig.heightMultiplier,
          width: 100 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppTheme.project4,
                    AppTheme.topBarBackgroundColor,
                    // AppTheme.project2,
                  ])),
          child: Center(
              child: Text(
            "Project has completed!\n" + "Review team members>>",
            style: TextStyle(color: Colors.white),
          ))),
    );
  }
}

class Allocation extends StatefulWidget {
  Project project;
  Allocation(this.project);

  @override
  _AllocationState createState() => _AllocationState();
}

class _AllocationState extends State<Allocation> {
  Map<String, dynamic> additionalPoints = new Map();
  Map<String, dynamic> pointsToMembers = new Map();
  final GlobalKey<FormState> _formKey = GlobalKey();
  PageController controller = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    widget.project =
        Provider.of<ManageProject>(context, listen: false).managedProject;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        elevation: 0,
        title:
            Text("Allocation of points", style: TextStyle(color: Colors.black)),
        // automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: PageView(
            controller: controller,
            children: <Widget>[
              AllocateToResourceDonors(widget.project, controller,
                  additionalPoints, pointsToMembers),
              AllocateToTeamMembers(widget.project, controller,
                  additionalPoints, pointsToMembers),
            ],
          ),
        ),
      ),
    );
  }
}
