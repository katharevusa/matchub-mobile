import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_outgoingRequest.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/customAlertDialog.dart';
import 'package:provider/provider.dart';

class ProjectOutgoingTabview extends StatefulWidget {
  // List<ResourceRequest> listOfIncomingRequests;
  num flag;
  // Function getAllIncomingResourceRequests;
  ProjectOutgoingTabview(
    this.flag,
  );
  // this.getAllIncomingResourceRequests);

  @override
  _ProjectOutgoingTabviewState createState() => _ProjectOutgoingTabviewState();
}

class _ProjectOutgoingTabviewState extends State<ProjectOutgoingTabview> {
  List<ResourceRequest> listOfOutgoingRequests = [];
  List<ResourceRequest> listOfOutgoingPending = [];
  List<ResourceRequest> listOfOutgoingApproved = [];
  List<ResourceRequest> listOfOutgoingRejected = [];
  List<ResourceRequest> listOfOutgoingExpired = [];
  bool _isLoading;
  @override
  void initState() {
    _isLoading = true;
    loadRequests();
    super.initState();
  }

  loadRequests() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageOutgoingRequest>(context, listen: false)
        .getAllProjectOutgoing(profile, accessToken);
    setState(() {
      _isLoading = false;
    });
    await clearList();
  }

  clearList() async {
    listOfOutgoingRequests =
        Provider.of<ManageOutgoingRequest>(context).listOfRequests;
    listOfOutgoingPending = [];
    listOfOutgoingApproved = [];
    listOfOutgoingRejected = [];
    listOfOutgoingExpired = [];
    for (ResourceRequest rr in listOfOutgoingRequests) {
      if (rr.status == "ON_HOLD") listOfOutgoingPending.add(rr);
      if (rr.status == "ACCEPTED") listOfOutgoingApproved.add(rr);
      if (rr.status == "REJECTED") listOfOutgoingRejected.add(rr);
      if (rr.status == "EXPIRED") listOfOutgoingExpired.add(rr);
    }
  }

  @override
  Widget build(BuildContext context) {
    // widget.getAllIncomingResourceRequests();
    return _isLoading
        ? Container(child: Center(child: Text("I am loading")))
        : listOfOutgoingRequests.isNotEmpty && widget.flag == 0
            ? SingleChildScrollView(
                child: Column(
                children: [
                  SizedBox(height: 30),
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listOfOutgoingPending.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RequestTicket(listOfOutgoingPending[index], 0);
                      }),
                ],
              ))
            : listOfOutgoingRequests.isNotEmpty && widget.flag == 1
                ? SingleChildScrollView(
                    child: Column(
                    children: [
                      SizedBox(height: 30),
                      ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: listOfOutgoingApproved.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RequestTicket(
                                listOfOutgoingApproved[index], 1);
                          }),
                    ],
                  ))
                : listOfOutgoingRequests.isNotEmpty && widget.flag == 2
                    ? SingleChildScrollView(
                        child: Column(
                        children: [
                          SizedBox(height: 30),
                          ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: listOfOutgoingRejected.length,
                              itemBuilder: (BuildContext context, int index) {
                                return RequestTicket(
                                    listOfOutgoingRejected[index], 1);
                              }),
                        ],
                      ))
                    : listOfOutgoingExpired.isNotEmpty && widget.flag == 3
                        ? SingleChildScrollView(
                            child: Column(
                            children: [
                              SizedBox(height: 30),
                              ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: listOfOutgoingExpired.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return RequestTicket(
                                        listOfOutgoingExpired[index], 1);
                                  }),
                            ],
                          ))
                        : SingleChildScrollView(
                            child: Center(
                                child: Text(
                                    "You have not made any resource donation request.")),
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
  Profile resourceOwner;
  // Future loader;
  Future resourceFuture;
  bool _isLoading = true;

  final Color bgColor = Color(0xffFD6592);
  final Color secondaryColor = Color(0xff324558);
  final Color primaryColor = Color(0xffF9E0E3);

  @override
  void initState() {
    // loader = load();
    _isLoading = true;
    resourceFuture = retrieveResource();
    super.initState();
  }

  /* Get the requestor*/
  retrieveResourceOwner() async {
    final url = 'authenticated/getAccount/${resource.resourceOwnerId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    resourceOwner = Profile.fromJson(responseData);
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
    await retrieveResourceOwner();
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

  terminate() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    final responseData = await ApiBaseHelper().deleteProtected(
        "authenticated/deleteResourceRequest?requestId=${widget.request.requestId}&terminatorId=${profile.accountId}",
        accessToken: Provider.of<Auth>(context).accessToken);
    _customAlertDialog(context, AlertDialogType.WARNING, "Terminated",
        "You have terminated the request!");
    await loadRequests();
  }

  loadRequests() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageOutgoingRequest>(context, listen: false)
        .getAllProjectOutgoing(profile, accessToken);
    setState(() {
      _isLoading = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            color: kPrimaryColor,
            child: Stack(
              children: <Widget>[
                Container(
                  width: 90,
                  height: 90,
                  color: AppTheme.selectedTabBackgroundColor,
                ),
                Container(
                  height: 400,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Resource requested:',
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
                            (widget.request.unitsRequired).toString() +
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Resource owner:',
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
                                  arguments: resourceOwner.accountId);
                            },
                            child: Text(
                              resourceOwner.name,
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
                      Divider(
                        height: 1,
                      ),
                      Text('From project:',
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
                      Divider(
                        height: 1,
                      ),
                      Text('Message:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          )),
                      Text(widget.request.message,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          )),
                      Text(
                          "Date: ${widget.request.requestCreationTime.year}-${widget.request.requestCreationTime.month}-${widget.request.requestCreationTime.day} ${widget.request.requestCreationTime.hour}:${widget.request.requestCreationTime.minute}:${widget.request.requestCreationTime.second}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          )),
                      Divider(
                        height: 1,
                      ),
                      if (widget.flag == 0) ...{
                        Row(
                          children: <Widget>[
                            Spacer(),
                            InkWell(
                              onTap: () {
                                terminate();
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
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                          ],
                        ),
                      }
                    ],
                  ),
                )
              ],
            ),
          );

/*

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
                      terminate();
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
                        "Terminate",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
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
        );*/
  }
}
