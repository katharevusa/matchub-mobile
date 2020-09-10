// import 'package:flutter/material.dart';
// import 'package:matchub_mobile/api/api_helper.dart';

// class OwnResourceDetailScreen extends StatefulWidget {
//   static const routeName = "/own-resource-detail";
//   @override
//   _OwnResourceDetailScreenState createState() =>
//       _OwnResourceDetailScreenState();
// }

// class _OwnResourceDetailScreenState extends State<OwnResourceDetailScreen> {
//   final routeArgs =
//       ModalRoute.of(context).settings.arguments as Map<String, String>;
//   final resourceTitle = routeArgs['title'];
//   // final categoryId = routeArgs['id'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(resourceTitle),
//       ),
//       body: SingleChildScrollView(
//         child: Center(child: Text("Own Resource detail")),
//       ),
//     );
//   }
// }
