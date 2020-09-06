import 'package:flutter/material.dart';
import 'package:matchub_mobile/model/individual.dart';

class Post with ChangeNotifier {
  String content;
  DateTime timeCreated;
  Individual postCreator;
  List<Comment> comments;

  Post({this.content, this.timeCreated, this.postCreator});
}

class Comment with ChangeNotifier {
  String content;
  DateTime timeCreated;
  Comment({
    this.content,
    this.timeCreated,
  });
}
