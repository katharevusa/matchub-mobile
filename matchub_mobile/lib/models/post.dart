import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  Post();

  num postId;
  String content;
  DateTime timeCreated;
  List photos;
  num originalPostId;
  num previousPostId;
  num likes;
  num postCreatorId;
  List listOfComments;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
