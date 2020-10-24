import 'package:matchub_mobile/models/index.dart';
import 'package:json_annotation/json_annotation.dart';

part 'taskEntity.g.dart';

@JsonSerializable()
class TaskEntity {
  TaskEntity({
    this.taskId,
    this.taskTitle,
    this.taskDescription,
    this.expectedDeadline,
    this.taskColumn,
    this.taskDoers  = const [],
  });

  num taskId;
  String taskTitle;
  String taskDescription;
  DateTime createdTime;
  DateTime expectedDeadline;
  TaskColumnEntity taskColumn;
  Map<String, dynamic> documents;
  Map<String, dynamic> labelAndColour;
  num taskLeaderId;
  num taskCreatorId;
  List<Profile> taskDoers;
  List<Comment> comments;

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);
  // Map<String, dynamic> toJson() => _$TaskEntityToJson(this);
}
