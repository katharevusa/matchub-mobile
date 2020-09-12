import 'package:matchub_mobile/model/resourceCategory.dart';

class Resource {
  String title;
  String description;
  List<String> uploadedFiles;
  DateTime startDateTime;
  DateTime endDateTime;
  bool available;
  ResourceCategory resourceCategory;

  Resource({
    this.title,
    this.description,
    this.startDateTime,
    this.resourceCategory,
    this.endDateTime,
    this.uploadedFiles = const [],
    this.available,
  });
}
