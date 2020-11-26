import 'package:matchub_mobile/models/index.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/task.dart';
import 'taskColumn.dart';

part 'kanban.g.dart';

@JsonSerializable()
class KanbanEntity {
    KanbanEntity({
      this.taskColumns
    });

    num kanbanBoardId;
    num projectId;
    String kanbanBoardTitle;
    String kanbanBoardDescription;
    String channelUid;
    List<TaskColumnEntity> taskColumns  = const [];

    factory KanbanEntity.fromJson(Map<String,dynamic> json) => _$KanbanEntityFromJson(json);
    Map<String, dynamic> toJson() => _$KanbanEntityToJson(this);
}
