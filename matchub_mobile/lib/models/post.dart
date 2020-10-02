import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
    Post();

    num postId;
    String content;
    DateTime timeCreated;
    List photos;
    String originalPostId;
    String previousPostId;
    num likes;
    String postCreatorId;
    List listOfComments;
    
    factory Post.fromJson(Map<String,dynamic> json) => _$PostFromJson(json);
    Map<String, dynamic> toJson() => _$PostToJson(this);
}
