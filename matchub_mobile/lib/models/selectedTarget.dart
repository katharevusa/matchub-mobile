import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'selectedTarget.g.dart';

@JsonSerializable()
class SelectedTarget {
    SelectedTarget();

    num selectedTargetId;
    Sdg sdg; 
    List<SdgTarget> sdgTargets;
    Project project;
    Profile profile;
    
    factory SelectedTarget.fromJson(Map<String,dynamic> json) => _$SelectedTargetFromJson(json);
}
 