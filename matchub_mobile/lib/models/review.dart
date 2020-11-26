import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  Review();

  num reviewId;
  String timeCreated;
  String content;
  num rating;
  Profile reviewer;
  Project project;
  Profile reviewReceiver;
  // Map<String,dynamic> reviewer;
  // Map<String,dynamic> project;
  // Map<String,dynamic> reviewReceiver;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
