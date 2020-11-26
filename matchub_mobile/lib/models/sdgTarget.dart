import 'package:json_annotation/json_annotation.dart';

part 'sdgTarget.g.dart';

@JsonSerializable()
class SdgTarget {
    SdgTarget();

    num sdgTargetId;
    String sdgTargetNumbering;
    String sdgTargetDescription;
    
    factory SdgTarget.fromJson(Map<String,dynamic> json) => _$SdgTargetFromJson(json);
    // Map<String, dynamic> toJson() => _$SdgTargetToJson(this);
}
