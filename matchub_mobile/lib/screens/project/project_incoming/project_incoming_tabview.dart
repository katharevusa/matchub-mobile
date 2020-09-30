import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/customAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:ticket_pass_package/ticket_pass.dart';

class ProjectIncomingTabview extends StatefulWidget {
  List<ResourceRequest> listOfIncomingRequests;
  num flag;
  // Function getAllIncomingResourceRequests;
  ProjectIncomingTabview(
    this.listOfIncomingRequests,
    this.flag,
  );
  // this.getAllIncomingResourceRequests);

  @override
  _ProjectIncomingTabviewState createState() => _ProjectIncomingTabviewState();
}

class _ProjectIncomingTabviewState extends State<ProjectIncomingTabview> {
  @override
  Widget build(BuildContext context) {
    // widget.getAllIncomingResourceRequests();
    return widget.listOfIncomingRequests.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 30),
              ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: widget.listOfIncomingRequests.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RequestTicket(
                        widget.listOfIncomingRequests[index], widget.flag);
                  }),
            ],
          ))
        : SingleChildScrollView(
            child: Center(
                child: Text("You do not have any resource donation request.")),
          );
  }
}

class RequestTicket extends StatefulWidget {
  ResourceRequest request;
  num flag;
  RequestTicket(this.request, this.flag);
  @override
  _RequestTicketState createState() => _RequestTicketState();
}

class _RequestTicketState extends State<RequestTicket> {
  ApiBaseHelper _helper = ApiBaseHelper();
  Resources resource;
  ResourceCategory resourceCategory;
  Project project;
  Profile requestor;
  // Future loader;
  Future resourceFuture;
  bool _isLoading = true;
  @override
  void initState() {
    // loader = load();
    _isLoading = true;
    resourceFuture = retrieveResource();
    super.initState();
  }

  /* Get the requestor*/
  retrieveRequestor() async {
    final url = 'authenticated/getAccount/${widget.request.requestorId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    requestor = Profile.fromJson(responseData);
  }

  /* Get the resource*/
  retrieveResource() async {
    final url =
        'authenticated/getResourceById?resourceId=${widget.request.resourceId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    resource = Resources.fromJson(responseData);
    print(resource.resourceName);
    await retrieveCategory();
    await retrieveRequestor();
    await retrieveProject();
    setState(() {
      _isLoading = false;
    });
  }

  /* Get the project*/
  retrieveProject() async {
    final responseData = await ApiBaseHelper().getProtected(
        "authenticated/getProject?projectId=${widget.request.projectId}",
        Provider.of<Auth>(this.context, listen: false).accessToken);
    project = Project.fromJson(responseData);
  }

  /* Get the resource category*/
  retrieveCategory() async {
    final url =
        'authenticated/getResourceCategoryById?resourceCategoryId=${resource.resourceCategoryId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(this.context).accessToken);
    resourceCategory = ResourceCategory.fromJson(responseData);
  }

  respondToRequest(bool response) async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    if (response == true) {
      final responseData = await ApiBaseHelper().getProtected(
          "authenticated/respondToResourceRequest?requestId=${widget.request.requestId}&responderId=${profile.accountId}&response=${true}",
          Provider.of<Auth>(this.context, listen: false).accessToken);
      _customAlertDialog(context, AlertDialogType.SUCCESS, "Accepted",
          "You have accepted the request!");
    } else {
      final responseData = await ApiBaseHelper().getProtected(
          "authenticated/respondToResourceRequest?requestId=${widget.request.requestId}&responderId=${profile.accountId}&response=${false}",
          Provider.of<Auth>(this.context, listen: false).accessToken);
      _customAlertDialog(context, AlertDialogType.WARNING, "Rejected",
          "You have rejected the request!");
    }
  }

  final Color bgColor = Color(0xffFD6592);
  final Color secondaryColor = Color(0xff324558);
  final Color primaryColor = Color(0xffF9E0E3);
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: resourceFuture,
    //   builder: (context, snapshot) => (snapshot.connectionState ==
    //           ConnectionState.done)
    //       ?
    return _isLoading
        ? Container()
        : Container(
            padding: EdgeInsets.all(8.0),
            child: TicketPass(
                alignment: Alignment.center,
                animationDuration: Duration(seconds: 1),
                expandedHeight: 450,
                expandIcon: CircleAvatar(
                  maxRadius: 10,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                expansionTitle: Text(
                  '',
                ),
                expansionChild: showMore(),
                separatorColor: Colors.red,
                separatorHeight: 2.0,
                color: Colors.white,
                curve: Curves.easeOut,
                titleColor: Colors.blue.shade900,
                shrinkIcon: Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    maxRadius: 10,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                ticketTitle: Text(
                  'More',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                titleHeight: 35,
                width: 320,
                height: 300,
                shadowColor: Colors.blue.withOpacity(0.5),
                elevation: 8,
                shouldExpand: true,

                //基础信息
                child: Container(
                  height: 200,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Resource donating:',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                              ResourceDetailScreen.routeName,
                              arguments: resource);
                        },
                        child: Text(
                          (resource.resourceName),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              color: secondaryColor),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Amount:',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                          Text(
                            (widget.request.unitsRequired *
                                        resourceCategory.perUnit)
                                    .toString() +
                                " " +
                                resourceCategory.unitName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: secondaryColor),
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                      ),
                      Text('Project to receive the resource:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(ProjectDetailScreen.routeName,
                              arguments: project.projectId);
                        },
                        child: Text(
                          project.projectTitle,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            color: secondaryColor,
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Donator:',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(ProfileScreen.routeName,
                                  arguments: requestor.accountId);
                            },
                            child: Text(
                              requestor.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                color: secondaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // if (widget.flag == 0) ...{
                      //   Row(
                      //     children: <Widget>[
                      //       Spacer(),
                      //       InkWell(
                      //         onTap: () {
                      //           terminate();
                      //         },
                      //         child: Container(
                      //           alignment: Alignment.center,
                      //           // padding: const EdgeInsets.all(16.0),
                      //           decoration: BoxDecoration(
                      //               border: Border(
                      //             bottom: BorderSide(
                      //               color: Colors.green,
                      //               width: 2.0,
                      //             ),
                      //           )),
                      //           child: Text(
                      //             "Terminate",
                      //             style: TextStyle(
                      //                 color: Colors.grey.shade600,
                      //                 fontSize: 13.0,
                      //                 fontWeight: FontWeight.w500),
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(width: 10.0),
                      //     ],
                      //   ),
                      // }
                    ],
                  ),
                )
                /*          child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
                  child: Container(
                    height: 140,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Resource Donating',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushNamed(
                                                    ResourceDetailScreen
                                                        .routeName,
                                                    arguments: resource);
                                          },
                                          child: Text(
                                            (resource.resourceName),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'AMOUNT',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                        Text(
                                          (widget.request.unitsRequired *
                                                      resourceCategory.perUnit)
                                                  .toString() +
                                              " " +
                                              resourceCategory.unitName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'FROM PROJECT',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pushNamed(
                                              ProjectDetailScreen.routeName,
                                              arguments: project.projectId);
                                        },
                                        child: Text(
                                          project.projectTitle,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'REQUESTOR',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pushNamed(ProfileScreen.routeName,
                                              arguments: requestor.accountId);
                                        },
                                        child: Text(
                                          requestor.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )*/
                ));
    // : Center(child: CircularProgressIndicator()),
    // );
  }

  _customAlertDialog(BuildContext context, AlertDialogType type, String title,
      String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: type,
          title: title,
          content: content,
        );
      },
    );
  }

  Widget showMore() {
    if (widget.flag == 0) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Message:"),
            SizedBox(height: 10.0),
            Text(
                "Requested at: ${widget.request.requestCreationTime.year}-${widget.request.requestCreationTime.month}-${widget.request.requestCreationTime.day} ${widget.request.requestCreationTime.hour}:${widget.request.requestCreationTime.minute}:${widget.request.requestCreationTime.second}"),
            SizedBox(height: 10.0),
            Text(
              widget.request.message,
              textAlign: TextAlign.justify,
            ),
            Divider(),
            Row(
              children: <Widget>[
                Spacer(),
                InkWell(
                  onTap: () {
                    respondToRequest(true);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    )),
                    child: Text(
                      "Accept",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    respondToRequest(false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    )),
                    child: Text(
                      "Reject",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Spacer(),
                const SizedBox(width: 10.0),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Message:"),
            SizedBox(height: 10.0),
            Text(
                "Requested at: ${widget.request.requestCreationTime.year}-${widget.request.requestCreationTime.month}-${widget.request.requestCreationTime.day} ${widget.request.requestCreationTime.hour}:${widget.request.requestCreationTime.minute}:${widget.request.requestCreationTime.second}"),
            SizedBox(height: 10.0),
            Text(
              widget.request.message,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      );
    }
  }
}
