import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageCompetition.dart';
import 'package:matchub_mobile/widgets/appExpansionTile.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class JoinCompetition extends StatefulWidget {
  static const routeName = "/join-competition";
  Competition competition;

  JoinCompetition({this.competition});
  @override
  _JoinCompetitionState createState() => _JoinCompetitionState();
}

class _JoinCompetitionState extends State<JoinCompetition> {
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  String foos = 'Select project';
  Profile myProfile;
  Project selectedProject;
//get a list of projects by the user

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Competition Form"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                "Join Competition",
                style: TextStyle(color: Colors.green),
              ),
              Text(
                "Please select the project:",
              ),
              Divider(),
              Row(
                children: [
                  Text(
                    "Choose project:",
                  ),
                ],
              ),
              AppExpansionTile(
                  key: expansionTile,
                  title: new Text(this.foos),
                  backgroundColor:
                      Theme.of(context).accentColor.withOpacity(0.025),
                  children: <Widget>[
                    for (Project p in myProfile.projectsOwned) ...{
                      new ListTile(
                        title: Text(p.projectTitle),
                        onTap: () {
                          setState(() {
                            this.foos = p.projectTitle;
                            selectedProject = p;
                            expansionTile.currentState.collapse();
                          });
                        },
                      ),
                    },
                  ]),
              SizedBox(height: 10.0),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                    child: Text("Submit"),
                    onPressed: () {
                      submit();
                      FocusScope.of(context).unfocus();
                      // Navigator.pop(context, true);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  submit() async {
    final url =
        "authenticated/joinCompetition?competitionId=${widget.competition.competitionId}&projectId=${selectedProject.projectId}";
    var accessToken = Provider.of<Auth>(context).accessToken;
    try {
      final response = await ApiBaseHelper.instance.postProtected(
        url,
      );
      await Provider.of<ManageCompetition>(context, listen: false)
          .getAllActiveCompetition();
      await Provider.of<ManageCompetition>(context, listen: false)
          .getAllCompetition();
      print("Success");
      Navigator.of(context).pop(true);
      Navigator.of(context).pop(true);
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }
}
