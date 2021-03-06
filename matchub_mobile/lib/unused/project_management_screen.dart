// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:matchub_mobile/models/project.dart';
// import 'package:matchub_mobile/screens/project/drawerMenu.dart';
// import 'package:matchub_mobile/screens/project/projectCreation/project_creation_screen.dart';
// import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';

// class ProjectManagement extends StatefulWidget {
//   @override
//   _ProjectManagementState createState() => _ProjectManagementState();
// }

// class _ProjectManagementState extends State<ProjectManagement> {
//   final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

//   var titleTextStyle = TextStyle(
//     color: Colors.black87,
//     fontSize: 20.0,
//     fontWeight: FontWeight.bold,
//   );

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final newProject = new Project();
//     final Color primaryColor = Color(0xffE70F0B);
//     List<bool> _isSelected = [true, false, false];
//     List<String> announcements = [
//       "Lorem ipsum dolor sit amet, consecteutur adsd Ut adipisicing dolore incididunt minim",
//       "Lorem ipsum dolor sit amet, consecteutur adsd Ut adipisicing dolore incididunt minim",
//       "Lorem ipsum dolor sit amet, consecteutur adsd Ut adipisicing dolore incididunt minim"
//     ];
//     final List<Map> collections = [
//       {
//         "title": "Setting up food stall in foriegn dorm",
//         "image": './././assets/images/pancake.jpg'
//       },
//       {
//         "title": "Photographer for food blogger",
//         "image": './././assets/images/fries.jpg'
//       },
//       {
//         "title": "Teaching program in Nepal",
//         "image": './././assets/images/fishtail.jpg'
//       },
//       {
//         "title": "Feed the birds in XYZ park",
//         "image": './././assets/images/kathmandu1.jpg'
//       },
//     ];

//     return Scaffold(
//       key: _key,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           'Management',
//           style: TextStyle(color: Colors.black, fontSize: 30.0),
//         ),
//         actions: <Widget>[
//           IconButton(
//             color: Colors.black,
//             icon: Icon(Icons.add),
//             onPressed: () => Navigator.of(context, rootNavigator: true).push(
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         ProjectCreationScreen(newProject: newProject))),
//           )
//         ],
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () {
//             _key.currentState.openDrawer();
//           },
//         ),
//       ),
//       drawer: DrawerMenu(),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: <Widget>[
//           ToggleButtons(
//             fillColor: primaryColor,
//             hoverColor: primaryColor,
//             renderBorder: true,
//             borderColor: Colors.grey.shade300,
//             color: Colors.grey.shade800,
//             selectedColor: Colors.white,
//             borderRadius: BorderRadius.circular(10.0),
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.fromLTRB(16.0, 16.0, 55.0, 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Icon(FontAwesomeIcons.list),
//                     const SizedBox(height: 16.0),
//                     Text(
//                       "All",
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Icon(FontAwesomeIcons.running),
//                     const SizedBox(height: 16.0),
//                     Text(
//                       "Progressing",
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Icon(FontAwesomeIcons.trophy),
//                     const SizedBox(height: 16.0),
//                     Text("Completed"),
//                   ],
//                 ),
//               ),
//             ],
//             isSelected: _isSelected,
//             onPressed: (int index) {
//               setState(() {
//                 _isSelected[index] = !_isSelected[index];
//               });
//               if (index == 0) {
//                 setState(() {});

//                 //show all project under the user
//               }
//               if (index == 1) {
//                 setState(() {});

//                 //show progressing project
//               }
//               if (index == 2) {
//                 //show completed project
//               }
//             },
//           ),
//           const SizedBox(height: 16.0),
//           Column(
//             children: <Widget>[
//               Container(
//                 color: Colors.white,
//                 height: 200.0,
//                 padding: EdgeInsets.symmetric(horizontal: 10.0),
//                 child: ListView.builder(
//                   physics: BouncingScrollPhysics(),
//                   scrollDirection: Axis.vertical,
//                   itemCount: collections.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Material(
//                         child: InkWell(
//                       // onTap: () => Navigator.push(
//                       //     context,
//                       //     new MaterialPageRoute(
//                       //         builder: (context) => ProjectDetailOverview())),
//                       child: Container(
//                           margin: EdgeInsets.symmetric(
//                               vertical: 5.0, horizontal: 10.0),
//                           width: 150.0,
//                           height: 200.0,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Expanded(
//                                   child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                       child: Container(
//                                           decoration: BoxDecoration(
//                                               image: DecorationImage(
//                                                   image: AssetImage(
//                                                     collections[index]['image'],
//                                                   ),
//                                                   fit: BoxFit.cover))))),
//                               SizedBox(
//                                 height: 5.0,
//                               ),
//                               Text(collections[index]['title'],
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .subhead
//                                       .merge(TextStyle(
//                                           color: Colors.grey.shade600)))
//                             ],
//                           )),
//                     ));
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16.0),
//           // SliverPadding(
//           //   padding: const EdgeInsets.all(26.0),
//           //   sliver: SliverGrid.count(
//           //     crossAxisCount: 2,
//           //     mainAxisSpacing: 10,
//           //     crossAxisSpacing: 10,
//           //     children: <Widget>[],
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
