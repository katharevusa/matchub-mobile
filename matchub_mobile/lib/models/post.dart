import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

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
  Profile postCreator;
  List<Comment> listOfComments;
  List likedUsersId;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
