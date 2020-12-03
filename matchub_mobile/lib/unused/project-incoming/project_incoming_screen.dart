// import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:matchub_mobile/api/api_helper.dart';
// import 'package:matchub_mobile/models/index.dart';
// import 'package:matchub_mobile/screens/project/drawerMenu.dart';
// import 'package:matchub_mobile/screens/project/project_incoming/project_incoming_tabview.dart';
// import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';
// import 'package:matchub_mobile/screens/resource/resource_incoming/resource_incoming_tabview.dart';
// import 'package:matchub_mobile/services/auth.dart';
// import 'package:provider/provider.dart';

// class ProjectIncomingScreen extends StatefulWidget {
//   static const routeName = "/resource-request-screen";
//   @override
//   _ProjectIncomingScreenState createState() => _ProjectIncomingScreenState();
// }

// class _ProjectIncomingScreenState extends State<ProjectIncomingScreen>
//     with SingleTickerProviderStateMixin {
//   ApiBaseHelper _helper = ApiBaseHelper.instance;
//   List<ResourceRequest> listOfIncomingRequests = [];
//   List<ResourceRequest> listOfIncomingPending = [];
//   List<ResourceRequest> listOfIncomingApproved = [];
//   List<ResourceRequest> listOfIncomingRejected = [];
//   // Future listOfIncomingRequestsFuture;

//   @override
//   void initState() {
//     // listOfIncomingRequestsFuture = getAllIncomingResourceDonationRequests();
//     super.initState();
//   }

//   // getAllIncomingResourceDonationRequests() async {
//   //   Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
//   //   final url =
//   //       'authenticated/getAllIncomingResourceDonationRequests?userId=${profile.accountId}';

//   //   final responseData = await _helper.getWODecode(
//   //       url, Provider.of<Auth>(this.context, listen: false).accessToken);
//   //   (responseData as List).forEach(
//   //       (e) => listOfIncomingRequests.add(ResourceRequest.fromJson(e)));

//   //   for (ResourceRequest rr in listOfIncomingRequests) {
//   //     if (rr.status == "ON_HOLD") listOfIncomingPending.add(rr);
//   //     if (rr.status == "ACCEPTED") listOfIncomingApproved.add(rr);
//   //     if (rr.status == "REJECTED") listOfIncomingRejected.add(rr);
//   //   }
//   // }

// /*Front end methods*/

//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//           drawer: DrawerMenu(),
//           appBar: AppBar(
//             centerTitle: true,
//             backgroundColor: Colors.blueGrey.shade800,
//             bottom: PreferredSize(
//                 child: TabBar(
//                     isScrollable: true,
//                     unselectedLabelColor: Colors.white.withOpacity(0.3),
//                     indicatorColor: Color(0xffE70F0B),
//                     labelColor: Color(0xffE70F0B),
//                     tabs: [
//                       Tab(
//                         icon: Row(
//                           children: [
//                             Text('  Pending'),
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         icon: Row(
//                           children: [
//                             Text('  Approved'),
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         icon: Row(
//                           children: [
//                             Text('  Rejected'),
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         icon: Row(
//                           children: [
//                             Text('  Expired'),
//                           ],
//                         ),
//                       ),
//                     ]),
//                 preferredSize: Size.fromHeight(40.0)),
//             actions: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(right: 16.0),
//                 child: Icon(Icons.search),
//               ),
//             ],
//           ),
//           body: TabBarView(
//             children: <Widget>[
//               Container(
//                 child: ProjectIncomingTabview(
//                   0,
//                 ),
//               ),
//               Container(
//                 child: ProjectIncomingTabview(
//                   1,
//                 ),
//               ),
//               Container(
//                 child: ProjectIncomingTabview(
//                   2,
//                 ),
//               ),
//               Container(
//                 child: ProjectIncomingTabview(
//                   3,
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
