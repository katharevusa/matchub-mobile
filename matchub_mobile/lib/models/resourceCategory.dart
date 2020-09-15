import 'package:json_annotation/json_annotation.dart';

part 'resourceCategory.g.dart';

@JsonSerializable()
class ResourceCategory {
    ResourceCategory();

    num resourceCategoryId;
    String resourceCategoryName;
    String resourceCategoryDescription;
    List resources;
    num communityPointsGuideline;
    num perUnit;
    
    factory ResourceCategory.fromJson(Map<String,dynamic> json) => _$ResourceCategoryFromJson(json);
    Map<String, dynamic> toJson() => _$ResourceCategoryToJson(this);
}
