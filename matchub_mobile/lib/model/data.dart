import 'package:matchub_mobile/model/resource.dart';
import 'package:matchub_mobile/model/resourceCategory.dart';

List<Resource> DUMMY_RESROUCES = [
  Resource(
    title: 'Ongoing1',
    description: 'Description1',
    startDateTime: DateTime.parse("2012-02-27 13:27:00"),
    resourceCategory: null,
    endDateTime: DateTime.parse("2021-02-27 13:27:00"),
    uploadedFiles: const ["string1"],
    available: true,
  ),
  Resource(
    title: 'Ongoing2',
    description: 'Description2',
    uploadedFiles: const ["string1"],
    resourceCategory: null,
    startDateTime: DateTime.parse("2012-02-27 13:27:00"),
    endDateTime: DateTime.parse("2021-02-27 13:27:00"),
    available: true,
  ),
  Resource(
    title: 'Ongoing3',
    description: 'Description3',
    uploadedFiles: const ["string1"],
    resourceCategory: null,
    startDateTime: DateTime.parse("2012-02-27 13:27:00"),
    endDateTime: DateTime.parse("2021-02-27 13:27:00"),
    available: false,
  ),
  Resource(
    title: 'Expired4',
    description: 'Description4',
    uploadedFiles: const ["string1"],
    resourceCategory: null,
    startDateTime: DateTime.parse("2012-02-27 13:27:00"),
    endDateTime: DateTime.parse("2020-02-27 13:27:00"),
    available: false,
  ),
];

// ignore: non_constant_identifier_names
List<ResourceCategory> DUMMY_RESOURCE_CATEGORY = [
  ResourceCategory("Food", "to feed"),
  ResourceCategory("Instructor", "to teach"),
  ResourceCategory("Technician", "to fix"),
];
