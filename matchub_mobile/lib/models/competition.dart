import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'competition.g.dart';

@JsonSerializable()
class Competition {
  Competition();

  num competitionId;
  String competitionTitle;
  String competitionDescription;
  DateTime startDate;
  DateTime endDate;
  double prizeMoney;
  List photos;
  Map<String, dynamic> documents;
  String competitionStatus;
  List<Project> projects;
  List<VoterCredential> voterCredentials;

  factory Competition.fromJson(Map<String, dynamic> json) =>
      _$CompetitionFromJson(json);
  Map<String, dynamic> toJson() => _$CompetitionToJson(this);
}
