import 'package:matchub_mobile/model/post.dart';
import 'package:matchub_mobile/model/resourceCategory.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

// ignore: non_constant_identifier_names
List<ResourceCategory> DUMMY_RESOURCE_CATEGORY = [
  ResourceCategory("Food", "to feed"),
  ResourceCategory("Instructor", "to teach"),
  ResourceCategory("Technician", "to fix"),
];
// List<Post> DUMMY_POSTS = [
//   Post(1,
//   "Write a welcome post: Create a welcome post for your Page that includes details about your business and why people should like your Page. Provide information about what you'll share on your Page, such as special offers, updates about your business and more.",
//   DateTime.now(),
//   Provider.of<Auth>(context).myProfile,
//   0,
//   )
// ]
