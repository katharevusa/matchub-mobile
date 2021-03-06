import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/survey/attemptSurvey.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  bool _isLoading = true;
  List<Survey> surveys = [];
  @override
  initState() {
    fetchSurveys();
    super.initState();
  }

  fetchSurveys() async {
    final responseData =
        await ApiBaseHelper.instance.getWODecode("authenticated/getAllSurveys");
    surveys = (responseData as List).map((e) => Survey.fromJson(e)).toList();
    surveys.retainWhere((sv) => sv.surveyResponses.indexWhere((sr)=>
        Provider.of<Auth>(context, listen: false)
            .myProfile.accountId
           == sr.respondent.accountId) ==
        -1);
    print(Provider.of<Auth>(context, listen: false)
        .myProfile
        .surveyResponses
        .length);
    print(surveys.length);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(title: Text("All MatcHub Surveys")),
            body: surveys.isEmpty
                ? Center(
                    child: Container(
                      width: 70*SizeConfig.widthMultiplier,
                      child: Text(
                          "You have completed all surveys. Check back next time!",
                          style: AppTheme.titleLight.copyWith(fontSize: 16)),
                    ))
                : GridView.builder(
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    AttemptSurvey(survey: surveys[index])));
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
