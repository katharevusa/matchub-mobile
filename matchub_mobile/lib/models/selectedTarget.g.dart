part of 'selectedTarget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedTarget _$SelectedTargetFromJson(Map<String, dynamic> json) {
  return SelectedTarget()
    ..selectedTargetId = json['selectedTargetId'] as num
    ..sdg = Sdg.fromJson(json['sdg'])
    ..sdgTargets = json['sdgTargets'] != null
        ? (json['sdgTargets'] as List)
            .map((i) => SdgTarget.fromJson(i))
            .toList()
        : []
    ..profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null
    ..project =
        json['project'] != null ? Project.fromJson(json['project']) : null;
}
