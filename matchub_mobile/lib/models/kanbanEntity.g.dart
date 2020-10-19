// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanbanEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KanbanEntity _$KanbanEntityFromJson(Map<String, dynamic> json) {
  return KanbanEntity()
    ..kanbanBoardId = json['kanbanBoardId'] as num
    ..projectId = json['projectId'] as num
    ..kanbanBoardTitle = json['kanbanBoardTitle'] as String
    ..kanbanBoardDescription = json['kanbanBoardDescription'] as String
    ..channelUid = json['channelUid'] as String
    ..taskColumns = json['taskColumns'] != null
        ? (json['taskColumns'] as List)
            .map((i) => TaskColumnEntity.fromJson(i))
            .toList()
        : [];

}