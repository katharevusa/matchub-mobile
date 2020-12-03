import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/messages.dart';
import 'package:matchub_mobile/screens/profile/profileScreen.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/writeReview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import '../../../style.dart';

class TeamMembersManagement extends StatefulWidget {
  Project project;

  TeamMembersManagement({this.project});
  @override
  _TeamMembersManagementState createState() => _TeamMembersManagementState();
}

class _TeamMembersManagementState extends State<TeamMembersManagement> {
  List<TruncatedProfile> allMembers = [];
  @override
  initState() {
    Provider.of<ManageProject>(context, listen: false)
        .getProject(widget.project.projectId);
    for (TruncatedProfile tp in widget.project.teamMembers) {
      if (!allMembers.contains(tp)) {
        allMembers.add(tp);
      }
    }
    for (TruncatedProfile tp in widget.project.projectOwners) {
      if (!allMembers.contains(tp)) {
        allMembers.add(tp);
      }
    }

    super.initState();
  }

  bool isExpanded = false;
  updateProject() async {
    try {
      final response = await Provider.of<ManageProject>(context).getProject(
        widget.project.projectId,
      );
      setState(() {});
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }

  respondToJoinRequest(int requestId, bool decision) async {
    final instance = Provider.of<Auth>(context, listen: false);
    try {
      await ApiBaseHelper.instance.postProtected(
          "authenticated/respondToJoinRequest?decisionMakerId=${instance.myProfile.accountId}&requestId=$requestId&decision=$decision",
          accessToken: instance.accessToken);
      await updateProject();
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }

  sendMessage(TruncatedProfile recipient) async {
    Profile myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    if (!await DatabaseMethods()
        .checkChatRoomExists(myProfile.uuid, recipient.uuid)) {
      DatabaseMethods().addChatRoom({
        "createdAt": DateTime.now(),
        "createdBy": myProfile.uuid,
        "members": [myProfile.uuid, recipient.uuid]..sort(),
        "recentMessage": {}
      });
    }
    String chatRoomId =
        await DatabaseMethods().getChatRoomId(myProfile.uuid, recipient.uuid);
    Profile recipientProfile = Profile.fromJson(await ApiBaseHelper.instance
        .getProtected("authenticated/getAccount/${recipient.accountId}",
            accessToken:
                Provider.of<Auth>(context, listen: false).accessToken));
    print(chatRoomId);
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) =>
            Messages(chatRoomId: chatRoomId, recipient: recipientProfile)));
  }

  _removeTeamMember(int teamMemberId) async {
    final instance = Provider.of<Auth>(context, listen: false);
    try {
      await ApiBaseHelper.instance.deleteProtected(
          "authenticated/removeTeamMember?projectId=${widget.project.projectId}&memberId=$teamMemberId&decisionMakerId=${instance.myProfile.accountId}",
          accessToken: instance.accessToken);
      await updateProject();
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }

  _addProjectOwner(int teamMemberId) async {
    final instance = Provider.of<Auth>(context, listen: false);
    final url =
        "authenticated/addProjectOwner?projOwnerId=${instance.myProfile.accountId}&projOwnerToAddId=$teamMemberId&projectId=${widget.project.projectId}";
    final response = await ApiBaseHelper.instance.putProtected(url);
    await updateProject();
  }

  _removeProjectOwner(int teamMemberId) async {
    final instance = Provider.of<Auth>(context, listen: false);
    final url =
        "authenticated/removeProjectOwner?editorId=${instance.myProfile.accountId}&projOwnerToRemoveId=$teamMemberId&projectId=${widget.project.projectId}";
    final response = await ApiBaseHelper.instance.putProtected(url);
    await updateProject();
  }

  @override
  Widget build(BuildContext context) {
    widget.project = Provider.of<ManageProject>(context).managedProject;
    return DefaultTabController(
        length: (widget.project.projectOwners.indexWhere((element) =>
                    element.accountId ==
                    Provider.of<Auth>(context, listen: false)
                        .myProfile
                        .accountId) !=
                -1)
            ? 2
            : 1,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: kScaffoldColor,
              elevation: 0,
              title: Text("Manage Team Members",
                  style: TextStyle(color: Colors.black)),
              // automaticallyImplyLeading: true,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    labelColor: Colors.white,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                        indicatorRadius: (40),
                        indicatorHeight: 25.0,
                        indicatorColor: kSecondaryColor,
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        padding: EdgeInsets.all(10)),
                    unselectedLabelColor: Colors.grey[600],
                    tabs: (widget.project.projectOwners.indexWhere((element) =>
                                element.accountId ==
                                Provider.of<Auth>(context, listen: false)
                                    .myProfile
                                    .accountId) !=
                            -1)
                        ? [
                            Tab(
                              text: ("Current"),
                            ),
                            Tab(
                              text: ("Requests"),
                            ),
                          ]
                        : [
                            Tab(
                              text: ("Current"),
                            ),
                          ],
                  ),
                ),
              ),
            ),
            body: (widget.project.projectOwners.indexWhere((element) =>
                        element.accountId ==
                        Provider.of<Auth>(context, listen: false)
                            .myProfile
                            .accountId) !=
                    -1)
                ? TabBarView(
                    children: [
                      buildCurrentTeamMembersView(),
                      buildJoinRequestsView(),
                    ],
                  )
                : TabBarView(
                    children: [
                      buildCurrentTeamMembersView(),
                    ],
                  )));
  }

  buildCurrentTeamMembersView() {
    // print(widget.project.teamMembers.length);
    // for (TruncatedProfile tp in widget.project.teamMembers) {
    //   if (!allMembers.contains(tp)) {
    //     allMembers.add(tp);
    //   }
    // }
    // for (TruncatedProfile tp in widget.project.projectOwners) {
    //   if (!allMembers.contains(tp)) {
    //     allMembers.add(tp);
    //   }
    // }

    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.2,
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: allMembers[index].profilePhoto.isEmpty
                          ? AssetImage("assets/images/avatar2.jpg")
                          : NetworkImage(
                              "${ApiBaseHelper.instance.baseUrl}${allMembers[index].profilePhoto.substring(30)}"),
                    ),
                    trailing: widget.project.projectOwners.indexWhere(
                                (element) =>
                                    element.accountId ==
                                    allMembers[index].accountId) !=
                            -1
                        ? Icon(Icons.star)
                        : Text(''),
                    title: Text(allMembers[index].name,
                        style: TextStyle(
                          color: Colors.grey[850],
                        ))),
                secondaryActions: (Provider.of<Auth>(context, listen: false)
                            .myProfile
                            .accountId ==
                        allMembers[index].accountId)
                    ? <Widget>[]
                    : (widget.project.projectOwners.indexWhere((element) =>
                                element.accountId ==
                                Provider.of<Auth>(context, listen: false)
                                    .myProfile
                                    .accountId) ==
                            -1)
                        //我不是owner的时候
                        ? <Widget>[
                            if (widget.project.projStatus == "COMPLETED")
                              IconSlideAction(
                                  caption: 'Review',
                                  color: AppTheme.project2,
                                  icon: Icons.rate_review,
                                  onTap: () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(WriteReview.routeName,
                                              arguments: {
                                            'receiver': allMembers[index],
                                            'project': widget.project
                                          })),
                          ]
                        : <Widget>[
                            widget.project.projectOwners.indexWhere((element) =>
                                        element.accountId ==
                                        allMembers[index].accountId) ==
                                    -1
                                ? IconSlideAction(
                                    caption: 'Promote',
                                    color: AppTheme.project4,
                                    icon: Icons.star,
                                    onTap: () => _addProjectOwner(
                                        allMembers[index].accountId),
                                  )
                                : IconSlideAction(
                                    caption: 'Demote',
                                    color: AppTheme.project4,
                                    icon: Icons.star,
                                    onTap: () => _removeProjectOwner(
                                        allMembers[index].accountId),
                                  ),
                            if (widget.project.projStatus == "COMPLETED")
                              IconSlideAction(
                                caption: 'Review',
                                color: AppTheme.project2,
                                icon: Icons.rate_review,
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => WriteReview(
                                            project: widget.project,
                                            receiver: allMembers[index]))),
                              ),
                            IconSlideAction(
                              caption: 'Remove',
                              color: Colors.red[300],
                              icon: Icons.delete,
                              onTap: () => _removeTeamMember(
                                  allMembers[index].accountId),
                            ),
                          ],
              );
            },
            itemCount: allMembers.length),
        if (allMembers.isEmpty)
          Container(
              height: 50 * SizeConfig.heightMultiplier,
              child: Center(
                  child: Text("No Team members in this project yet..."))),
      ],
    );
  }

  buildJoinRequestsView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Theme(
          data: ThemeData(
            accentColor: kSecondaryColor,
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            tilePadding:
                EdgeInsets.only(bottom: 0, left: 16, right: 16, top: 8),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: widget.project.joinRequests[index].requestor
                      .profilePhoto.isEmpty
                  ? AssetImage("assets/images/avatar.png")
                  : NetworkImage(
                      "${ApiBaseHelper.instance.baseUrl}${widget.project.joinRequests[index].requestor.profilePhoto.substring(30)}"),
            ),
            title: Text(widget.project.joinRequests[index].requestor.name,
                style: TextStyle(
                  color: Colors.grey[850],
                )),
            // onExpansionChanged: (bool expanding) =>
            //     setState(() => this.isExpanded = expanding),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier,
                    vertical: 2 * SizeConfig.heightMultiplier),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Application Date:"),
                                Text(
                                    "${DateFormat.yMMMd().format(widget.project.joinRequests[index].requestCreationTime)}",
                                    style: AppTheme.searchLight),
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status"),
                                Text(
                                    "${widget.project.joinRequests[index].status}",
                                    style: AppTheme.searchLight),
                              ]),
                          Row(children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(FlutterIcons.message_square_fea),
                              onPressed: () => sendMessage(
                                  widget.project.joinRequests[index].requestor),
                            ),
                            IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(FlutterIcons.eye_fea),
                                onPressed: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(ProfileScreen.routeName,
                                            arguments: widget
                                                .project
                                                .joinRequests[index]
                                                .requestor
                                                .accountId)),
                          ])
                        ]),
                    if (widget.project.joinRequests[index].status == "ON_HOLD")
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              shape: Border(
                                  bottom: BorderSide(
                                      width: 2, color: Colors.green[300])),
                              child: Text("Approve"),
                              onPressed: () => respondToJoinRequest(
                                  widget.project.joinRequests[index]
                                      .joinRequestId,
                                  true),
                            ),
                            SizedBox(width: 5),
                            FlatButton(
                              shape: Border(
                                  bottom: BorderSide(
                                      width: 2, color: Colors.red[300])),
                              child: Text("Reject"),
                              onPressed: () => respondToJoinRequest(
                                  widget.project.joinRequests[index]
                                      .joinRequestId,
                                  false),
                            ),
                          ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: widget.project.joinRequests.length,
    );
  }
}
