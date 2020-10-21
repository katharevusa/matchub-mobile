part of 'sdg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sdg _$SdgFromJson(Map<String, dynamic> json) {
  return Sdg()
    ..sdgId = json['sdgId'] as num
    ..sdgName = json['sdgName'] as String
    ..sdgDescription = json['sdgDescription'] as String;
  // ..projects = json['projects'] as List;
}

Map<String, dynamic> _$SdgToJson(Sdg instance) => <String, dynamic>{
      'sdgId': instance.sdgId,
      'sdgName': instance.sdgName,
      'sdgDescription': instance.sdgDescription,
      'projects': instance.projects
    };
