import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'surveyResponse.g.dart';

@JsonSerializable()
class SurveyResponse {
    SurveyResponse();

    num surveyResponseId;
    DateTime timestamp;
    TruncatedProfile respondent;

    factory SurveyResponse.fromJson(Map<String,dynamic> json) => _$SurveyResponseFromJson(json);
}
 