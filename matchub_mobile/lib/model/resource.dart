class Resource {
  String title;
  String description;
  List<String> category;
  DateTime startDateTime;
  DateTime endDateTime;
  String files;
  String status;

  Resource(
    this.title,
    this.description,
    this.category,
    this.startDateTime,
    this.endDateTime,
    this.files,
    this.status,
  );
}
