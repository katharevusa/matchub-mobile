// import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:matchub_mobile/api/api_helper.dart';
// import 'package:matchub_mobile/models/index.dart';
// import 'package:matchub_mobile/screens/project/drawerMenu.dart';
// import 'package:matchub_mobile/screens/project/project_outgoing/project_outgoing_tabview.dart';
// // import 'package:matchub_mobile/screens/resource/navDrawer.dart';
// import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';
// import 'package:matchub_mobile/screens/resource/resource_incoming/resource_incoming_tabview.dart';
// import 'package:matchub_mobile/screens/resource/resource_outgoing/resource_outgoing_tabview.dart';
// import 'package:matchub_mobile/services/auth.dart';
// import 'package:provider/provider.dart';

// class OutgoingProjectScreen extends StatefulWidget {
//   // static const routeName = "/resource-request-screen";//
//   @override
//   _OutgoingProjectScreenState createState() => _OutgoingProjectScreenState();
// }

// class _OutgoingProjectScreenState extends State<OutgoingProjectScreen>
//     with SingleTickerProviderStateMixin {
//   // ApiBaseHelper _helper = ApiBaseHelper();
//   // List<ResourceRequest> listOfOutgoingRequests = [];
//   // List<ResourceRequest> listOfOutgoingPending = [];
//   // List<ResourceRequest> listOfOutgoingApproved = [];
//   // List<ResourceRequest> listOfOutgoingRejected = [];
//   // Future listOfOutgoingRequestsFuture;

//   @override
//   void initState() {
//     // listOfOutgoingRequestsFuture = getAllOutgingResourceRequests();
//     super.initState();
//   }

// /*HTTP calls*/

//   // getAllOutgingResourceRequests() async {
//   //   Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
//   //   final url =
//   //       'authenticated/getAllOutgoingResourceRequests?userId=${profile.accountId}';

//   //   final responseData = await _helper.getWODecode(
//   //       url, Provider.of<Auth>(this.context, listen: false).accessToken);
//   //   (responseData as List).forEach(
//   //       (e) => listOfOutgoingRequests.add(ResourceRequest.fromJson(e)));

//   //   for (ResourceRequest rr in listOfOutgoingRequests) {
//   //     if (rr.status == "ON_HOLD") listOfOutgoingPending.add(rr);
//   //     if (rr.status == "ACCEPTED") listOfOutgoingApproved.add(rr);
//   //     if (rr.status == "REJECTED") listOfOutgoingRejected.add(rr);
//   //   }
//   // }

// /*Front end methods*/
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: 4,
//         child:
//             // FutureBuilder(
//             //   future: listOfOutgoingRequestsFuture,
//             //   builder: (context, snapshot) => (snapshot.connectionState ==
//             //           ConnectionState.done)
//             Scaffold(
//                 drawer: DrawerMenu(),
//                 appBar: AppBar(
//                   centerTitle: true,
//                   backgroundColor: Colors.blueGrey.shade800,
//                   bottom: PreferredSize(
//                       child: TabBar(
//                           isScrollable: true,
//                           unselectedLabelColor: Colors.white.withOpacity(0.3),
//                           indicatorColor: Color(0xffE70F0B),
//                           labelColor: Color(0xffE70F0B),
//                           tabs: [
//                             Tab(
//                               icon: Row(
//                                 children: [
//                                   Text('  Pending'),
//                                 ],
//                               ),
//                             ),
//                             Tab(
//                               icon: Row(
//                                 children: [
//                                   Text('  Approved'),
//                                 ],
//                               ),
//                             ),
//                             Tab(
//                               icon: Row(
//                                 children: [
//                                   Text('  Rejected'),
//                                 ],
//                               ),
//                             ),
//                             Tab(
//                               icon: Row(
//                                 children: [
//                                   Text('  Expired'),
//                                 ],
//                               ),
//                             ),
//                           ]),
//                       preferredSize: Size.fromHeight(40.0)),
//                   actions: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(right: 16.0),
//                       child: Icon(Icons.search),
//                     ),
//                   ],
//                 ),
//                 body: TabBarView(
//                   children: <Widget>[
//                     Container(
//                       child: ProjectOutgoingTabview(
//                         0,
//                       ),
//                     ),
//                     Container(
//                       child: ProjectOutgoingTabview(
//                         1,
//                       ),
//                     ),
//                     Container(
//                       child: ProjectOutgoingTabview(
//                         2,
//                       ),
//                     ),
//                     Container(
//                       child: ProjectOutgoingTabview(
//                         3,
//                       ),
//                     ),
//                   ],
//                 )));
//   }
// }
