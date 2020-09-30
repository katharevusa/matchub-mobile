import 'package:json_annotation/json_annotation.dart';

part 'resourceRequest.g.dart';

@JsonSerializable()
class ResourceRequest {
    ResourceRequest();

    num requestId;
    DateTime requestCreationTime;
    String status;
    num requestorId;
    String requestorEnum;
    num resourceId;
    num projectId;
    num unitsRequired;
    String message;
    
    factory ResourceRequest.fromJson(Map<String,dynamic> json) => _$ResourceRequestFromJson(json);
    Map<String, dynamic> toJson() => _$ResourceRequestToJson(this);
}
