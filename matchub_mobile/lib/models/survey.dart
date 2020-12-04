import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'survey.g.dart';

@JsonSerializable()
class Survey {
    Survey();

    num surveyId;
    String name;
    String description;
    DateTime createdDate;
    // DateTime openDate;
    // DateTime closeDate;
    bool expired;
    List<SurveyQuestion> questions;
    List<SurveyResponse> surveyResponses;
    
    factory Survey.fromJson(Map<String,dynamic> json) => _$SurveyFromJson(json);
}
 