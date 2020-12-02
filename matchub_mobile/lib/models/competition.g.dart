// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Competition _$CompetitionFromJson(Map<String, dynamic> json) {
  return Competition()
    ..competitionId = json['competitionId'] as num
    ..competitionTitle = json['competitionTitle'] as String
    ..competitionDescription = json['competitionDescription'] as String
    ..startDate = DateTime.parse(json['startDate'])
    ..endDate = DateTime.parse(json['endDate'])
    ..prizeMoney = json['prizeMoney'] as double
    ..photos = json['photos'] as List
    ..documents = json['documents'] as Map<String, dynamic>
    ..competitionStatus = json['competitionStatus'] as String
    ..projects = json['projects'] != null
        ? (json['projects'] as List).map((i) => Project.fromJson(i)).toList()
        : []
    ..voterCredentials = json['voterCredentials'] != null
        ? (json['voterCredentials'] as List)
            .map((i) => VoterCredential.fromJson(i))
            .toList()
        : [];
}

Map<String, dynamic> _$CompetitionToJson(Competition instance) =>
    <String, dynamic>{
      'competitionId': instance.competitionId,
      'competitionTitle': instance.competitionTitle,
      'competitionDescription': instance.competitionDescription,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'prizeMoney': instance.prizeMoney,
      'photos': instance.photos,
      'documents': instance.documents,
      'competitionStatus': instance.competitionStatus,
      'projects': instance.projects,
      'voterCredentials': instance.voterCredentials,
    };
