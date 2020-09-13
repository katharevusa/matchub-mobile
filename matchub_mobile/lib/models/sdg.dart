import 'package:json_annotation/json_annotation.dart';

part 'sdg.g.dart';

@JsonSerializable()
class Sdg {
    Sdg();

    num sdgId;
    String sdgName;
    String sdgDescription;
    List projects;
    
    factory Sdg.fromJson(Map<String,dynamic> json) => _$SdgFromJson(json);
    Map<String, dynamic> toJson() => _$SdgToJson(this);
}
