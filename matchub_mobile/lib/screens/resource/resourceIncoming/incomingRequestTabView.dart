import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/profile/profileScreen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/managOutgoingRequest.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/customAlertDialog.dart';
import 'package:provider/provider.dart';

class IncomingRequestTabview extends StatefulWidget {
  num flag;
  IncomingRequestTabview(this.flag);
  @override
  _IncomingRequestTabviewState createState() => _IncomingRequestTabviewState();
}

class _IncomingRequestTabviewState extends State<IncomingRequestTabview> {
  List<ResourceRequest> requestToMyProjects = [];
  List<ResourceRequest> requestToMyResource = [];
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
        .getRequestsToMyResource(profile, accessToken);
    await Provider.of<ManageOutgoingRequest>(context, listen: false)
        .getRequestsToMyProject(profile, accessToken);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    requestToMyProjects =
        Provider.of<ManageOutgoingRequest>(context).requestToMyProject;
    requestToMyResource =
        Provider.of<ManageOutgoingRequest>(context).requestToMyResource;
    return _isLoading
        ? Container(child: Center(child: Text("I am loading")))
        : widget.flag == 0
            ? Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.95), BlendMode.dstATop),
                        image: AssetImage('assets/images/Mailbox.gif'),
                        fit: BoxFit.scaleDown)),
                child: SingleChildScrollView(
                  child: requestToMyProjects.isNotEmpty
                      ? Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: requestToMyProjects.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RequestCard(
                                    requestToMyProjects[index],
                                    0,
                                  );
                                }),
                          ],
                        )
                      : Center(
                          child: Text("You have not receive request yet.")),
                ),
              )
            : widget.flag == 1
                ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.white.withOpacity(0.95),
                                BlendMode.dstATop),
                            image: AssetImage('assets/images/Mailbox.gif'),
                            fit: BoxFit.scaleDown)),
                    child: SingleChildScrollView(
                      child: requestToMyResource.isNotEmpty
                          ? Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: requestToMyResource.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return RequestCard(
                                        requestToMyResource[index],
                                        1,
                                      );
                                    }),
                              ],
                            )
                          : Center(
                              child: Text("You have not receive request yet.")),
                    ),
                  )
                : Container();
  }
}

class RequestCard extends StatefulWidget {
  ResourceRequest request;
  num flag;

  RequestCard(this.request, this.flag);

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  Resources resource;
  ResourceCategory resourceCategory;
  Project project;
  Profile requestor;
  bool _isLoading = true;

  @override
  void initState() {
    _isLoading = true;
    retrieveResource();
    super.initState();
  }

  retrieveRequestor() async {
    final url = 'authenticated/getAccount/${widget.request.requestorId}';
    final responseData = await _helper.getProtected(
        url, accessToken: Provider.of<Auth>(context, listen: false).accessToken);
    requestor = Profile.fromJson(responseData);
  }

  retrieveResource() async {
    final url =
        'authenticated/getResourceById?resourceId=${widget.request.resourceId}';
    final responseData = await _helper.getProtected(
        url, accessToken: Provider.of<Auth>(context, listen: false).accessToken);
    resource = Resources.fromJson(responseData);
    print(resource.resourceName);
    await retrieveCategory();
    await retrieveRequestor();
    await retrieveProject();
    setState(() {
      _isLoading = false;
    });
  }

  retrieveProject() async {
    final responseData = await ApiBaseHelper.instance.getProtected(
        "authenticated/getProject?projectId=${widget.request.projectId}",
        accessToken: Provider.of<Auth>(this.context, listen: false).accessToken);
    project = Project.fromJson(responseData);
  }

  retrieveCategory() async {
    final url =
        'authenticated/getResourceCategoryById?resourceCategoryId=${resource.resourceCategoryId}';
    final responseData = await _helper.getProtected(
        url, accessToken: Provider.of<Auth>(this.context).accessToken);
    resourceCategory = ResourceCategory.fromJson(responseData);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Container(
            height: 35 * SizeConfig.heightMultiplier,
            constraints:
                BoxConstraints(minHeight: 35 * SizeConfig.heightMultiplier),
            margin: EdgeInsets.symmetric(
                vertical: 1 * SizeConfig.heightMultiplier,
                horizontal: 2 * SizeConfig.heightMultiplier),
            padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(4, 3),
                  blurRadius: 10,
                  color: Colors.grey[850].withOpacity(0.1),
                ),
                BoxShadow(
                  offset: Offset(-4, -3),
                  blurRadius: 10,
                  color: Colors.grey[850].withOpacity(0.1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(children: [
                      Text(
                        DateFormat('E')
                            .format(widget.request.requestCreationTime),
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      Text(
                        widget.request.requestCreationTime.month.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        DateFormat('MMM')
                            .format(widget.request.requestCreationTime),
                        style: TextStyle(color: Colors.blue, fontSize: 10),
                      )
                    ]),
                    SizedBox(width: 15),
                    Container(
                      color: Colors.black,
                      height: 30,
                      width: 1,
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(ResourceDetailScreen.routeName,
                                    arguments: resource);
                          },
                          child: Text(
                            (resource.resourceName),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        if (widget.flag == 0) ...{
                          Text(
                            "Donation amount: " +
                                (widget.request.unitsRequired *
                                        resourceCategory.perUnit)
                                    .toString() +
                                " " +
                                resourceCategory.unitName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        } else ...{
                          Text(
                            "Required amount: " +
                                (widget.request.unitsRequired *
                                        resourceCategory.perUnit)
                                    .toString() +
                                " " +
                                resourceCategory.unitName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          )
                        }
                      ],
                    ),
                    Spacer(),
                    popUpMenu(widget.request, context)
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(ProjectDetailScreen.routeName,
                          arguments: project);
                    },
                    child: widget.flag == 0
                        ? Text(
                            "I am donating to your project: " +
                                project.projectTitle +
                                ". " +
                                widget.request.message,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          )
                        : Text(
                            "I am requesting your resource to my project: " +
                                project.projectTitle +
                                ". " +
                                widget.request.message,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          )),
                SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: ClipOval(
                          child: AttachmentImage(requestor.profilePhoto),
                        )),
                    SizedBox(width: 10),
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
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                        color: widget.request.status == "ON_HOLD"
                            ? Colors.yellow
                            : widget.request.status == "ACCEPTED"
                                ? Colors.green.shade300
                                : Colors.red.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          widget.request.status,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ));
  }

  respondToRequest(bool response) async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    if (response == true) {
      final responseData = await ApiBaseHelper.instance.getProtected(
          "authenticated/respondToResourceRequest?requestId=${widget.request.requestId}&responderId=${profile.accountId}&response=${true}",
           accessToken:Provider.of<Auth>(this.context, listen: false).accessToken);
      _customAlertDialog(context, AlertDialogType.SUCCESS, "Accepted",
          "You have accepted the request!");
      await loadRequests();
    } else {
      final responseData = await ApiBaseHelper.instance.getProtected(
          "authenticated/respondToResourceRequest?requestId=${widget.request.requestId}&responderId=${profile.accountId}&response=${false}",
           accessToken:Provider.of<Auth>(this.context, listen: false).accessToken);
      _customAlertDialog(context, AlertDialogType.WARNING, "Rejected",
          "You have rejected the request!");
      await loadRequests();
    }
  }

  loadRequests() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageOutgoingRequest>(context, listen: false)
        .getRequestsToMyResource(profile, accessToken);
    await Provider.of<ManageOutgoingRequest>(context, listen: false)
        .getRequestsToMyProject(profile, accessToken);
    setState(() {
      _isLoading = true;
    });
    // widget.listOfIncomingRequests =
    //     Provider.of<ManageIncomingResourceRequest>(context).listOfRequests;
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

  Widget popUpMenu(ResourceRequest currentPost, BuildContext context) {
    return PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            respondToRequest(true);
          }
          if (value == 2) {
            respondToRequest(false);
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                      ),
                      Text('Accept')
                    ],
                  )),
              PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                      ),
                      Text('Reject')
                    ],
                  )),
            ]);
  }
}
