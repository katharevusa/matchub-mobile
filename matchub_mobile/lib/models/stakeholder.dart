import 'package:json_annotation/json_annotation.dart';

part 'stakeholder.g.dart';

@JsonSerializable()
class Stakeholder {
    Stakeholder();

    num accountId;
    String uuid;
    String email;
    bool accountLocked;
    bool accountExpired;
    bool disabled;
    List roles;
    
    factory Stakeholder.fromJson(Map<String,dynamic> json) => _$StakeholderFromJson(json);
    Map<String, dynamic> toJson() => _$StakeholderToJson(this);
}
