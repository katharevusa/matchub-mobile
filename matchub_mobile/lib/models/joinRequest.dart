import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'joinRequest.g.dart';

@JsonSerializable()
class JoinRequest {
  JoinRequest();

  num joinRequestId;
  DateTime requestCreationTime;
  String status;
  TruncatedProfile requestor;
  Project project;

  factory JoinRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinRequestFromJson(json);
  Map<String, dynamic> toJson() => _$JoinRequestToJson(this);
}
