import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class AttemptSurvey extends StatefulWidget {
  AttemptSurvey({this.survey});
  Survey survey;
  @override
  _AttemptSurveyState createState() => _AttemptSurveyState();
}

class _AttemptSurveyState extends State<AttemptSurvey> {
  List<SurveyQuestion> questionsToDisplay = [];
  List<Map<String, dynamic>> surveyResponses = [];
  bool _reachedLastQuestion = false;
  @override
  void initState() {
    createSurveyForm();
    super.initState();
  }

  createSurveyForm() {
    for (int i = 0; i < widget.survey.questions.length; i++) {
      SurveyQuestion s = widget.survey.questions[i];
      questionsToDisplay.add(s);
      surveyResponses.add(
          {"questionId": s.questionId, "selectedOptionIds": [], "input": null});
      if (s.hasBranching) break;
    }
  }

  selectOptions(List optionIdsSelected, int conditionalQuestionId) {
    _reachedLastQuestion = false;
    SurveyQuestion cQ = widget.survey.questions.firstWhere(
        (element) => element.questionId == conditionalQuestionId,
        orElse: () => null);
    if (cQ != null) {
      if (cQ.hasBranching) {
        for (SurveyOption sO in cQ.options) {
          print(sO.questionOptionsId.toString());
          if (cQ.optionToQuestion
              .containsKey(sO.questionOptionsId.toString())) {
            print("Removed ==========================");
            //removing questions from all the previous options selected
            print("before: ${questionsToDisplay.length}");
            //recursively delete lal other questions from this conditional question
            selectOptions(
                [], cQ.optionToQuestion[sO.questionOptionsId.toString()]);
            questionsToDisplay.removeWhere((element) =>
                element.questionId.toString() ==
                cQ.optionToQuestion[sO.questionOptionsId.toString()]
                    .toString());
            print("after: ${questionsToDisplay.length}");
            surveyResponses.removeWhere((element) =>
                element['questionId'] ==
                cQ.optionToQuestion[sO.questionOptionsId.toString()]);
            print(surveyResponses);
          }
        }

        for (int i in optionIdsSelected) {
          print("Add ==========================");
          if (cQ.optionToQuestion.containsKey(i.toString())) {
            //adding questions from current options selected
            SurveyQuestion questionToAdd = widget.survey.questions.firstWhere(
                (element) =>
                    element.questionId == cQ.optionToQuestion[i.toString()],
                orElse: () => null); // survey question to add from option
            if (questionToAdd != null) {
              questionsToDisplay
                  .removeWhere((e) => e.questionId == questionToAdd.questionId);
              questionsToDisplay.add(questionToAdd);
              if (!questionToAdd.hasBranching) {
                SurveyQuestion nextQuestion =
                    widget.survey.questions.firstWhere(
                  (element) =>
                      element.questionId == questionToAdd.nextQuestionId,
                  orElse: () => null,
                );
                if (nextQuestion != null &&
                    questionsToDisplay.indexWhere(
                            (sQ) => sQ.questionId == nextQuestion.questionId) ==
                        -1) {
                  questionsToDisplay.add(nextQuestion);
                }
              }
              if (surveyResponses.indexWhere((element) =>
                      element['questionId'] == questionToAdd.questionId) ==
                  -1) {
                surveyResponses.add({
                  "questionId": questionToAdd.questionId,
                  "selectedOptionIds": [],
                  "input": null
                });
              }
            }
          }
        }
      }
    }
    questionsToDisplay.sort((a, b) => a.questionId.compareTo(b.questionId));
    if (questionsToDisplay.last.nextQuestionId == null ||
        questionsToDisplay.last.nextQuestionId == -1) {
      _reachedLastQuestion = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Attempt Survey"),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0,
                      color: Colors.grey[850].withOpacity(0.3),
                      offset: Offset(2, 2),
                      blurRadius: 3)
                ]),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: kPrimaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.survey.name, style: AppTheme.titleLight),
                      SizedBox(height: 10),
                      Text(
                        widget.survey.description,
                        style: AppTheme.buttonLight.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return QuestionCard(
                    question: questionsToDisplay[index],
                    questionNo: index,
                    selectOptions: selectOptions,
                    response: surveyResponses.firstWhere(
                        (element) =>
                            element['questionId'] ==
                            questionsToDisplay[index].questionId, orElse: () {
                      Map<String, dynamic> m = {
                        "questionId": questionsToDisplay[index].questionId,
                        "selectedOptionIds": [],
                        "input": null
                      };
                      surveyResponses.add(m);
                      return m;
                    }));
              },
              itemCount: questionsToDisplay.length),
          if (_reachedLastQuestion)
            RaisedButton(
                color: kKanbanColor,
                onPressed: () async {
                  print(surveyResponses);
                  for (Map<String, dynamic> sr in surveyResponses) {
                    if ((sr['input'] == null || sr['input'].isEmpty )&&
                        (sr['selectedOptionIds'] as List).isEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                  "You have not responded to every question!"),
                              actions: <Widget>[
                                FlatButton(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Okay'),
                                ),
                              ],
                            );
                          });
                      return;
                    }
                  }
                  ApiBaseHelper.instance.postProtected("authenticated/createFullSurveyResponse", body: json.encode({
                    "respondentId": Provider.of<Auth>(context,listen:false).myProfile.accountId,
                    "surveyId": widget.survey.surveyId,
                    "questionResponses": surveyResponses
                  }));
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Submit Survey",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 2 * SizeConfig.textMultiplier),
                )),
        ]),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  QuestionCard({
    Key key,
    @required this.question,
    @required this.questionNo,
    @required this.response,
    @required this.selectOptions,
  }) : super(key: key);

  final int questionNo;
  Function selectOptions;
  final SurveyQuestion question;
  Map<String, dynamic> response;

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                spreadRadius: 0,
                color: Colors.grey[850].withOpacity(0.3),
                offset: Offset(2, 2),
                blurRadius: 3)
          ]),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                "${widget.questionNo + 1}.  ${widget.question.question}",
                style: AppTheme.selectedTabLight.copyWith(fontSize: 14)),
          ),
          SizedBox(height: 10),
          widget.question.questionTypeSwitch == 0
              ? ListView.builder(
                  itemBuilder: (_, idx) => RadioListTile<int>(
                    activeColor: kPrimaryColor,
                    title: Text(widget.question.options[idx].optionContent,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.grey[850])),
                    selected: widget.response['selectedOptionIds'].contains(
                        widget.question.options[idx].questionOptionsId),
                    groupValue: (widget.response['selectedOptionIds'] as List)
                            .isNotEmpty
                        ? widget.response['selectedOptionIds'].first
                        : 0,
                    value: widget.question.options[idx].questionOptionsId,
                    onChanged: (int value) {
                      setState(() {
                        widget.response['selectedOptionIds'].clear();
                        widget.response['selectedOptionIds'].add(value);
                        print(widget.response['selectedOptionIds']);
                        print("Selected");
                        if (widget.question.hasBranching) {
                          widget.selectOptions(
                              widget.response['selectedOptionIds'],
                              widget.question.questionId);
                        }
                      });
                    },
                  ),
                  itemCount: widget.question.options.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                )
              : widget.question.questionTypeSwitch == 1
                  ? ListView.builder(
                      itemBuilder: (_, idx) => CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: kPrimaryColor,
                        title: Text(widget.question.options[idx].optionContent,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Colors.grey[850])),
                        value: widget.response['selectedOptionIds'].contains(
                            widget.question.options[idx].questionOptionsId),
                        onChanged: (value) {
                          setState(() {
                            if (value) {
                              widget.response['selectedOptionIds'].add(widget
                                  .question.options[idx].questionOptionsId);
                            } else {
                              widget.response['selectedOptionIds'].remove(widget
                                  .question.options[idx].questionOptionsId);
                            }
                            print(widget.response['selectedOptionIds']);
                            print("Selected");
                            if (widget.question.hasBranching) {
                              widget.selectOptions(
                                  widget.response['selectedOptionIds'],
                                  widget.question.questionId);
                            }
                          });
                        },
                      ),
                      itemCount: widget.question.options.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Response',
                          labelStyle:
                              TextStyle(color: Colors.grey[850], fontSize: 12),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kSecondaryColor),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: kSecondaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 9,
                        maxLength: 200,
                        maxLengthEnforced: true,
                        onChanged: (value) {
                          widget.response['input'] = value.trim();
                        },
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Required";
                          }
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
