import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'gamificationPointTiers.g.dart';

@JsonSerializable()
class Gamification {
  Gamification();

  num gamificationPointTiersId;
  num pointsToComment;
  num pointsToDownvote;
  num pointsToAnonymousReview;
  num pointsToSpotlight;

  factory Gamification.fromJson(Map<String, dynamic> json) =>
      _$GamificationFromJson(json);
}
