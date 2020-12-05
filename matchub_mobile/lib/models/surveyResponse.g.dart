part of 'surveyResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyResponse _$SurveyResponseFromJson(Map<String, dynamic> json) {
  return SurveyResponse()
    ..surveyResponseId = json['surveyResponseId'] as num
    ..timestamp = DateTime.parse(json['timestamp'])
    ..respondent = json['respondent'] != null ? TruncatedProfile.fromJson(json['respondent']) : null;
}
