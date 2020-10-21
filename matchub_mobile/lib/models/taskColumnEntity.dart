import 'package:matchub_mobile/models/index.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/taskEntity.dart';

part 'taskColumnEntity.g.dart';

@JsonSerializable()
class TaskColumnEntity {
  TaskColumnEntity({
    this.taskColumnId,
    this.columnTitle,
    this.columnDescription,
    this.kanbanBoardId,
    this.listOfTasks = const [],
  });

  num taskColumnId;
  String columnTitle;
  String columnDescription;
  num kanbanBoardId;
  List<TaskEntity> listOfTasks;

  factory TaskColumnEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskColumnEntityFromJson(json);
  // Map<String, dynamic> toJson() => _$TaskColumnEntityToJson(this);
}
