part of 'surveyOption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyOption _$SurveyOptionFromJson(Map<String, dynamic> json) {
  return SurveyOption()
    ..questionOptionsId = json['questionOptionsId'] as num
    ..optionContent = json['optionContent'] as String;
    // ..question = SurveyQuestion.fromJson(json['question']);
}