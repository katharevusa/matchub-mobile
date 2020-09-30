import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post  with ChangeNotifier {
    Post();

    num postId;
    String content;
    DateTime timeCreated;
    List photos;
    String originalPostId;
    String postCreatorId;
    String previousPostId;
    num likes;
    Map<String,dynamic> postCreator;
    List listOfComments;
    
    factory Post.fromJson(Map<String,dynamic> json) => _$PostFromJson(json);
    Map<String, dynamic> toJson() => _$PostToJson(this);
}
