import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
    Comment();

    num commentId;
    DateTime timeCreated;
    String content;
    num accountId;
    String commentType;
    
    factory Comment.fromJson(Map<String,dynamic> json) => _$CommentFromJson(json);
}
enum CommentType{
      Post_Comment,
    Task_Comment
}