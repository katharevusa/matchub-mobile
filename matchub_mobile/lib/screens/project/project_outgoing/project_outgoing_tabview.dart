import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class ProjectOutgoingTabview extends StatefulWidget {
  List<ResourceRequest> listOfIncomingRequests;
  num flag;
  // Function getAllIncomingResourceRequests;
  ProjectOutgoingTabview(
    this.listOfIncomingRequests,
    this.flag,
  );
  // this.getAllIncomingResourceRequests);

  @override
  _ProjectOutgoingTabviewState createState() => _ProjectOutgoingTabviewState();
}

class _ProjectOutgoingTabviewState extends State<ProjectOutgoingTabview> {
  @override
  Widget build(BuildContext context) {
    // widget.getAllIncomingResourceRequests();
    return widget.listOfIncomingRequests.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 30),
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.listOfIncomingRequests.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RequestTicket(
                        widget.listOfIncomingRequests[index], widget.flag);
                  }),
            ],
          ))
        : SingleChildScrollView(
            child:
                Center(child: Text("You have not request for any resource.")),
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
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            color: primaryColor,
            child: Stack(
              children: <Widget>[
                Container(
                  width: 90,
                  height: 90,
                  color: bgColor,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Resource onwer:',
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
