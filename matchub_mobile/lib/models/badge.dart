import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge {
    Badge();

    num badgeId;
    String badgeType;
    String badgeTitle;
    String icon;
    Map<String,dynamic> project;
    
    factory Badge.fromJson(Map<String,dynamic> json) => _$BadgeFromJson(json);
    Map<String, dynamic> toJson() => _$BadgeToJson(this);
}
