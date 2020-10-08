// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:matchub_mobile/api/api_helper.dart';
// import 'package:matchub_mobile/models/index.dart';
// import 'package:matchub_mobile/screens/profile/profile_screen.dart';
// import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
// import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
// import 'package:matchub_mobile/services/auth.dart';
// import 'package:matchub_mobile/services/manage_incoming_resourceRequest.dart';
// import 'package:matchub_mobile/sizeconfig.dart';
// import 'package:matchub_mobile/style.dart';
// import 'package:matchub_mobile/widgets/customAlertDialog.dart';
// import 'package:provider/provider.dart';
// import 'package:ticket_pass_package/ticket_pass.dart';

// class ResourceIncomingPending extends StatefulWidget {
//   //List<ResourceRequest> listOfIncomingRequests;
//   num flag;
//   // Function loadRequest;
//   ResourceIncomingPending(
//     // this.listOfIncomingRequests,
//     // this.loadRequest,
//     this.flag,
//   );
//   // this.getAllIncomingResourceRequests);

//   @override
//   _ResourceIncomingPendingState createState() =>
//       _ResourceIncomingPendingState();
// }

// class _ResourceIncomingPendingState extends State<ResourceIncomingPending> {
//   List<ResourceRequest> listOfIncomingRequests = [];
//   List<ResourceRequest> listOfIncomingPending = [];
//   List<ResourceRequest> listOfIncomingApproved = [];
//   List<ResourceRequest> listOfIncomingRejected = [];
//   List<ResourceRequest> listOfIncomingExpired = [];
//   bool _isLoading;

//   @override
//   void initState() {
//     _isLoading = true;
//     loadRequests();
//     super.initState();
//   }

//   loadRequests() async {
//     Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
//     var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
//     await Provider.of<ManageIncomingResourceRequest>(context, listen: false)
//         .getAllIncomingResourceRequests(profile, accessToken);
//     setState(() {
//       _isLoading = false;
//     });
//     await clearList();
//   }

//   clearList() async {
//     listOfIncomingRequests =
//         Provider.of<ManageIncomingResourceRequest>(context).listOfRequests;
//     listOfIncomingPending = [];
//     listOfIncomingApproved = [];
//     listOfIncomingRejected = [];
//     listOfIncomingExpired = [];
//     for (ResourceRequest rr in listOfIncomingRequests) {
//       if (rr.status == "ON_HOLD") listOfIncomingPending.add(rr);
//       if (rr.status == "ACCEPTED") listOfIncomingApproved.add(rr);
//       if (rr.status == "REJECTED") listOfIncomingRejected.add(rr);
//       if (rr.status == "EXPIRED") listOfIncomingExpired.add(rr);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? Container(child: Center(child: Text("I am loading")))
//         : listOfIncomingRequests.isNotEmpty && widget.flag == 0
//             ? SingleChildScrollView(
//                 child: Column(
//                 children: [
//                   ListView.builder(
//                       shrinkWrap: true,
//                       physics: BouncingScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       itemCount: listOfIncomingPending.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return RequestTicket(
//                           listOfIncomingPending[index],
//                           0,
//                         );
//                       }),
//                 ],
//               ))
//             : listOfIncomingRequests.isNotEmpty && widget.flag == 1
//                 ? SingleChildScrollView(
//                     child: Column(
//                     children: [
//                       ListView.builder(
//                           shrinkWrap: true,
//                           physics: BouncingScrollPhysics(),
//                           scrollDirection: Axis.vertical,
//                           itemCount: listOfIncomingApproved.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return RequestTicket(
//                               listOfIncomingApproved[index],
//                               1,
//                             );
//                           }),
//                     ],
//                   ))
//                 : listOfIncomingRequests.isNotEmpty && widget.flag == 2
//                     ? SingleChildScrollView(
//                         child: Column(
//                         children: [
//                           ListView.builder(
//                               shrinkWrap: true,
//                               physics: BouncingScrollPhysics(),
//                               scrollDirection: Axis.vertical,
//                               itemCount: listOfIncomingRejected.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return RequestTicket(
//                                   listOfIncomingRejected[index],
//                                   1,
//                                 );
//                               }),
//                         ],
//                       ))
//                     : listOfIncomingExpired.isNotEmpty && widget.flag == 3
//                         ? SingleChildScrollView(
//                             child: Column(
//                             children: [
//                               ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: BouncingScrollPhysics(),
//                                   scrollDirection: Axis.vertical,
//                                   itemCount: listOfIncomingExpired.length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return RequestTicket(
//                                       listOfIncomingExpired[index],
//                                       1,
//                                     );
//                                   }),
//                             ],
//                           ))
//                         : SingleChildScrollView(
//                             child: Center(
//                                 child: Text(
//                                     "No project is requesting for your resources.")),
//                           );
//   }
// }

// class RequestTicket extends StatefulWidget {
//   ResourceRequest request;
//   num flag;

//   RequestTicket(
//     this.request,
//     this.flag,
//   );
//   @override
//   _RequestTicketState createState() => _RequestTicketState();
// }

// class _RequestTicketState extends State<RequestTicket> {
//   ApiBaseHelper _helper = ApiBaseHelper();
//   Resources resource;
//   ResourceCategory resourceCategory;
//   Project project;
//   Profile requestor;
//   // Future loader;
//   Future resourceFuture;
//   bool _isLoading = true;
//   @override
//   void initState() {
//     // loader = load();
//     _isLoading = true;
//     resourceFuture = retrieveResource();
//     super.initState();
//   }

//   /* Get the requestor*/
//   retrieveRequestor() async {
//     final url = 'authenticated/getAccount/${widget.request.requestorId}';
//     final responseData = await _helper.getProtected(
//         url, Provider.of<Auth>(context, listen: false).accessToken);
//     requestor = Profile.fromJson(responseData);
//   }

//   /* Get the resource*/
//   retrieveResource() async {
//     final url =
//         'authenticated/getResourceById?resourceId=${widget.request.resourceId}';
//     final responseData = await _helper.getProtected(
//         url, Provider.of<Auth>(context, listen: false).accessToken);
//     resource = Resources.fromJson(responseData);
//     print(resource.resourceName);
//     await retrieveCategory();
//     await retrieveRequestor();
//     await retrieveProject();
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   /* Get the project*/
//   retrieveProject() async {
//     final responseData = await ApiBaseHelper().getProtected(
//         "authenticated/getProject?projectId=${widget.request.projectId}",
//         Provider.of<Auth>(this.context, listen: false).accessToken);
//     project = Project.fromJson(responseData);
//   }

//   /* Get the resource category*/
//   retrieveCategory() async {
//     final url =
//         'authenticated/getResourceCategoryById?resourceCategoryId=${resource.resourceCategoryId}';
//     final responseData = await _helper.getProtected(
//         url, Provider.of<Auth>(this.context).accessToken);
//     resourceCategory = ResourceCategory.fromJson(responseData);
//   }

//   respondToRequest(bool response) async {
//     if (response == true) {
//       final responseData = await ApiBaseHelper().getProtected(
//           "authenticated/respondToResourceRequest?requestId=${widget.request.requestId}&responderId=${resource.resourceOwnerId}&response=${true}",
//           Provider.of<Auth>(this.context, listen: false).accessToken);
//       _customAlertDialog(context, AlertDialogType.SUCCESS, "Accepted",
//           "You have accepted the request!");
//       await loadRequests();
//     } else {
//       final responseData = await ApiBaseHelper().getProtected(
//           "authenticated/respondToResourceRequest?requestId=${widget.request.requestId}&responderId=${resource.resourceOwnerId}&response=${false}",
//           Provider.of<Auth>(this.context, listen: false).accessToken);
//       _customAlertDialog(context, AlertDialogType.WARNING, "Rejected",
//           "You have rejected the request!");
//       await loadRequests();
//     }
//   }

//   loadRequests() async {
//     Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
//     var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
//     await Provider.of<ManageIncomingResourceRequest>(context, listen: false)
//         .getAllIncomingResourceRequests(profile, accessToken);
//     setState(() {
//       _isLoading = true;
//     });
//     // widget.listOfIncomingRequests =
//     //     Provider.of<ManageIncomingResourceRequest>(context).listOfRequests;
//   }

//   final Color bgColor = Color(0xffFD6592);
//   final Color secondaryColor = Color(0xff324558);
//   final Color primaryColor = Color(0xffF9E0E3);

//   @override
//   Widget build(BuildContext context) {
//     // return FutureBuilder(
//     //   future: resourceFuture,
//     //   builder: (context, snapshot) => (snapshot.connectionState ==
//     //           ConnectionState.done)
//     //       ?
//     return _isLoading
//         ? Container()
//         : Container(
//             padding: EdgeInsets.all(8.0),
//             child: TicketPass(
//                 alignment: Alignment.center,
//                 animationDuration: Duration(seconds: 1),
//                 expandedHeight: 600,
//                 expandIcon: CircleAvatar(
//                   backgroundColor: kSecondaryColor,
//                   maxRadius: 10,
//                   child: Icon(
//                     Icons.keyboard_arrow_down,
//                     color: Colors.white,
//                     size: 15,
//                   ),
//                 ),
//                 expansionTitle: Text(
//                   '',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 expansionChild: showMore(),
//                 separatorColor: Colors.red,
//                 separatorHeight: 2.0,
//                 color: Colors.white,
//                 curve: Curves.easeOut,
//                 titleColor: kSecondaryColor,
//                 shrinkIcon: Align(
//                   alignment: Alignment.centerRight,
//                   child: CircleAvatar(
//                     backgroundColor: kSecondaryColor,
//                     maxRadius: 10,
//                     child: Icon(
//                       Icons.keyboard_arrow_up,
//                       color: Colors.white,
//                       size: 15,
//                     ),
//                   ),
//                 ),
//                 ticketTitle: Text(
//                   'More',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 13,
//                   ),
//                 ),
//                 titleHeight: 50,
//                 width: 320,
//                 height: 600,
//                 shadowColor: primaryColor,
//                 elevation: 8,
//                 shouldExpand: true,

//                 //基础信息
//                 // child: Padding(
//                 //   padding:
//                 //       const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
//                 child: Container(
//                   height: 200,
//                   color: Colors.white,
//                   padding: const EdgeInsets.all(16.0),
//                   margin: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text('Resource requested:',
//                           style: TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.w400)),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.of(context, rootNavigator: true).pushNamed(
//                               ResourceDetailScreen.routeName,
//                               arguments: resource);
//                         },
//                         child: Text(
//                           (resource.resourceName),
//                           style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w400,
//                               decoration: TextDecoration.underline,
//                               color: secondaryColor),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text('Amount:',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w400,
//                               )),
//                           Text(
//                             (widget.request.unitsRequired *
//                                         resourceCategory.perUnit)
//                                     .toString() +
//                                 " " +
//                                 resourceCategory.unitName,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 13,
//                                 color: secondaryColor),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         height: 1,
//                       ),
//                       Text('From project:',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w400,
//                           )),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.of(
//                             context,
//                             rootNavigator: true,
//                           ).pushNamed(ProjectDetailScreen.routeName,
//                               arguments: project.projectId);
//                         },
//                         child: Text(
//                           project.projectTitle,
//                           textAlign: TextAlign.justify,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13,
//                             decoration: TextDecoration.underline,
//                             color: secondaryColor,
//                           ),
//                         ),
//                       ),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text('Requestor:',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.of(
//                                 context,
//                                 rootNavigator: true,
//                               ).pushNamed(ProfileScreen.routeName,
//                                   arguments: requestor.accountId);
//                             },
//                             child: Container(
//                             width: SizeConfig.widthMultiplier * 60,
//                             child: Text(
//                               requestor.name,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 decoration: TextDecoration.underline,
//                                 color: secondaryColor,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),)
//                         ],
//                       ),

//                       // if (widget.flag == 0) ...{
//                       //   Row(
//                       //     children: <Widget>[
//                       //       Spacer(),
//                       //       InkWell(
//                       //         onTap: () {
//                       //           terminate();
//                       //         },
//                       //         child: Container(
//                       //           alignment: Alignment.center,
//                       //           // padding: const EdgeInsets.all(16.0),
//                       //           decoration: BoxDecoration(
//                       //               border: Border(
//                       //             bottom: BorderSide(
//                       //               color: Colors.green,
//                       //               width: 2.0,
//                       //             ),
//                       //           )),
//                       //           child: Text(
//                       //             "Terminate",
//                       //             style: TextStyle(
//                       //                 color: Colors.grey.shade600,
//                       //                 fontSize: 13.0,
//                       //                 fontWeight: FontWeight.w500),
//                       //           ),
//                       //         ),
//                       //       ),
//                       //       const SizedBox(width: 10.0),
//                       //     ],
//                       //   ),
//                       // }
//                     ],
//                   ),
//                 )
//                 /*            child: Container(
//                     height: 170,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 2.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Expanded(
//                             child: Container(
//                               child: Row(
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Text(
//                                           'RESOURCE REQUESTED',
//                                           style: TextStyle(
//                                               color: Colors.black
//                                                   .withOpacity(0.5)),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.of(context,
//                                                     rootNavigator: true)
//                                                 .pushNamed(
//                                                     ResourceDetailScreen
//                                                         .routeName,
//                                                     arguments: resource);
//                                           },
//                                           child: Text(
//                                             (resource.resourceName),
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 decoration:
//                                                     TextDecoration.underline,
//                                                 color: Colors.red),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Text(
//                                           'AMOUNT',
//                                           style: TextStyle(
//                                             color:
//                                                 Colors.black.withOpacity(0.5),
//                                           ),
//                                         ),
//                                         Text(
//                                           (widget.request.unitsRequired *
//                                                       resourceCategory.perUnit)
//                                                   .toString() +
//                                               " " +
//                                               resourceCategory.unitName,
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.red),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(
//                                         'FROM PROJECT',
//                                         style: TextStyle(
//                                             color:
//                                                 Colors.black.withOpacity(0.5)),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           Navigator.of(
//                                             context,
//                                             rootNavigator: true,
//                                           ).pushNamed(
//                                               ProjectDetailScreen.routeName,
//                                               arguments: project.projectId);
//                                         },
//                                         child: Text(
//                                           project.projectTitle,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               decoration:
//                                                   TextDecoration.underline,
//                                               color: Colors.red),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(
//                                         'REQUESTOR',
//                                         style: TextStyle(
//                                             color:
//                                                 Colors.black.withOpacity(0.5)),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           Navigator.of(
//                                             context,
//                                             rootNavigator: true,
//                                           ).pushNamed(ProfileScreen.routeName,
//                                               arguments: requestor.accountId);
//                                         },
//                                         child: Text(
//                                           requestor.name,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               decoration:
//                                                   TextDecoration.underline,
//                                               color: Colors.red),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),*/
//                 ));
//     // : Center(child: CircularProgressIndicator()),
//     // );
//   }

//   _customAlertDialog(BuildContext context, AlertDialogType type, String title,
//       String content) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomAlertDialog(
//           type: type,
//           title: title,
//           content: content,
//         );
//       },
//     );
//   }

//   Widget showMore() {
//     if (widget.flag == 0) {
//       return Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text("Message:"),
//             SizedBox(height: 10.0),
//             Text(
//                 "Requested at: ${widget.request.requestCreationTime.year}-${widget.request.requestCreationTime.month}-${widget.request.requestCreationTime.day} ${widget.request.requestCreationTime.hour}:${widget.request.requestCreationTime.minute}:${widget.request.requestCreationTime.second}"),
//             SizedBox(height: 10.0),
//             Text(
//               widget.request.message,
//               textAlign: TextAlign.justify,
//             ),
//             SizedBox(height: 10.0),
//             Divider(
//               height: 20,
//             ),
//             Row(
//               children: <Widget>[
//                 Spacer(),
//                 InkWell(
//                   onTap: () {
//                     respondToRequest(true);
//                   },
//                   child: Container(
//                     alignment: Alignment.center,
//                     // padding: const EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                         border: Border(
//                       bottom: BorderSide(
//                         color: Colors.green,
//                         width: 2.0,
//                       ),
//                     )),
//                     child: Text(
//                       "Accept",
//                       style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 13.0,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//                 Spacer(),
//                 InkWell(
//                   onTap: () {
//                     respondToRequest(false);
//                   },
//                   child: Container(
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         border: Border(
//                       bottom: BorderSide(
//                         color: Colors.red,
//                         width: 2.0,
//                       ),
//                     )),
//                     child: Text(
//                       "Reject",
//                       style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 13.0,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//                 Spacer(),
//                 const SizedBox(width: 10.0),
//               ],
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text("Message:"),
//             SizedBox(height: 10.0),
//             Text(
//                 "Requested at: ${widget.request.requestCreationTime.year}-${widget.request.requestCreationTime.month}-${widget.request.requestCreationTime.day} ${widget.request.requestCreationTime.hour}:${widget.request.requestCreationTime.minute}:${widget.request.requestCreationTime.second}"),
//             SizedBox(height: 10.0),
//             Text(
//               widget.request.message,
//               textAlign: TextAlign.justify,
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
