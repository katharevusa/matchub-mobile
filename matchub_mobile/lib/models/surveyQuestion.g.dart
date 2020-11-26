part of 'surveyQuestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyQuestion _$SurveyQuestionFromJson(Map<String, dynamic> json) {
  return SurveyQuestion()
    ..questionId = json['questionId'] as num
    ..nextQuestionId = json['nextQuestionId'] ?? -1
    ..question = json['question'] as String
    ..optionToQuestion = json['optionToQuestion'] as Map<String, dynamic>
    ..hasBranching = json['hasBranching'] as bool
    ..questionType = json['questionType'] as String
    ..questionTypeSwitch = json['questionType'] == "MULTIPLE_CHOICE_QUESTION"
        ? 0
        : json['questionType'] == "MULTIPLE_RESPONSE_QUESTION"
            ? 1
            : 2
    ..options = json['options'] != null
        ? (json['options'] as List)
            .map((i) => SurveyOption.fromJson(i))
            .toList()
        : [];
}
