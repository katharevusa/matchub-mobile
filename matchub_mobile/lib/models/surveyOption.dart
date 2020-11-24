import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'surveyOption.g.dart';

@JsonSerializable()
class SurveyOption {
    SurveyOption();

    num questionOptionsId;
    String optionContent;
    SurveyQuestion question;
    factory SurveyOption.fromJson(Map<String,dynamic> json) => _$SurveyOptionFromJson(json);
}
 