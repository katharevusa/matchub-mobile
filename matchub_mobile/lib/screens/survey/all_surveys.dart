import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/survey/attempt_survey.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  bool _isLoading = true;
  List<Survey> surveys;
  @override
  Widget build(BuildContext context) {
    surveys = Provider.of<Auth>(context, listen: false).myProfile.surveys;
    print(surveys.length);
    return Scaffold(
      appBar: AppBar(title: Text("All MatcHub Surveys")),
      body: surveys.isEmpty ? Center(child:Text("No Active Surveys", style: AppTheme.titleLight)): GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
              childAspectRatio: 1,
              crossAxisCount: 2),
          itemCount: surveys.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => AttemptSurvey(survey: surveys[index])));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: Text(DateFormat.yMMMd()
                              .format(surveys[index].createdDate))),
                      SizedBox(height: 10),
                      Text(
                        surveys[index].name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kKanbanColor),
                      ),
                      SizedBox(height: 20),
                      Text(
                        surveys[index].description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
