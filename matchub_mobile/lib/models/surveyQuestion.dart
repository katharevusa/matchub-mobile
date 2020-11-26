import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'surveyQuestion.g.dart';

@JsonSerializable()
class SurveyQuestion {
    SurveyQuestion();

    num questionId;
    String question;
    num nextQuestionId;
    Map<String, dynamic> optionToQuestion;
    bool hasBranching;
    String questionType;
    List<SurveyOption> options;
    num questionTypeSwitch;

    factory SurveyQuestion.fromJson(Map<String,dynamic> json) => _$SurveyQuestionFromJson(json);
}
 