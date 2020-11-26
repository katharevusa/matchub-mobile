part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Survey _$SurveyFromJson(Map<String, dynamic> json) {
  return Survey()
    ..surveyId = json['surveyId'] as num
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..createdDate = DateTime.parse(json['createdDate'])
    // ..openDate = DateTime.parse(json['openDate'])
    // ..closeDate = DateTime.parse(json['closeDate'])
    ..expired = json['expired'] as bool
    ..questions = json['questions'] != null
        ? (json['questions'] as List)
            .map((i) => SurveyQuestion.fromJson(i))
            .toList()
        : [];
}