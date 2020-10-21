// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskColumnEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskColumnEntity _$TaskColumnEntityFromJson(Map<String, dynamic> json) {
  return TaskColumnEntity()
    ..taskColumnId = json['taskColumnId'] as num
    ..columnTitle = json['columnTitle'] as String
    ..columnDescription = json['columnDescription'] as String
    ..kanbanBoardId = json['kanbanBoardId'] as num
    ..listOfTasks = json['listOfTasks'] != null
        ? (json['listOfTasks'] as List)
            .map((i) => TaskEntity.fromJson(i))
            .toList()
        : [];

}