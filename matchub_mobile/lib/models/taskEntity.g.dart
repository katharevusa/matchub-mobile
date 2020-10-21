// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskEntity _$TaskEntityFromJson(Map<String, dynamic> json) {
  return TaskEntity()
    ..taskId = json['taskId'] as num
    ..taskTitle = json['taskTitle'] as String
    ..taskDescription = json['taskDescription'] as String
    ..createdTime = json['createdTime'] != null ? DateTime.parse(json['createdTime']) : null
    ..expectedDeadline = json['expectedDeadline']  != null ? DateTime.parse(json['expectedDeadline']) : null
    ..taskColumn = TaskColumnEntity.fromJson(json['taskColumn'])
    ..documents = json['documents'] as Map<String, dynamic>
    ..labelAndColour = json['labelAndColour'] as Map<String, dynamic>
    ..taskLeaderId = json['taskLeaderId'] as num
    ..taskDoers = json['taskdoers'] != null
        ? (json['taskdoers'] as List)
            .map((i) => Profile.fromJson(i))
            .toList()
        : [];

}