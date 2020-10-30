import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'channel_screen.dart';
import 'edit_channel.dart';
import 'edit_members.dart';

class ChannelSettings extends StatefulWidget {
  final Map<String, dynamic> channelData;
  final Project project;

  ChannelSettings({this.channelData, this.project});
  @override
  _ChannelSettingsState createState() => _ChannelSettingsState();
}

class _ChannelSettingsState extends State<ChannelSettings> {
  List<Profile> members = [];
  bool _isLoading;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    _isLoading = true;
    getMembersDetails();
    super.initState();
  }

  exitChannelSettings(value) {
    if (value != null && value) {
      Navigator.of(context).popUntil(ModalRoute.withName(ChannelsScreen.routeName));
    }
  }

  getMembersDetails() async {
    for (String uuid in widget.channelData['members']) {
      final response = await ApiBaseHelper.instance.getProtected(
          "authenticated/getAccountByUUID/$uuid",
          accessToken: Provider.of<Auth>(context, listen: false).accessToken);
      members.add(Profile.fromJson(response));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    bool loggedInUserIsAdmin =
        widget.channelData['admins'].contains(myProfile.uuid);
    bool loggedInUserIsOwner =
        widget.channelData['createdBy'] == myProfile.uuid;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Channel Info"),
        actions: [
          (loggedInUserIsAdmin || loggedInUserIsOwner)
              ? PopupMenuButton(
                  padding: EdgeInsets.zero,
                  offset: Offset(0, 50),
                  icon: Icon(
                    FlutterIcons.ellipsis_v_faw5s,
                    size: 20,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditChannel(
                                    widget.channelData,
                                  ),
                                ),
                              ).then((value) => exitChannelSettings(value));
                            },
                            dense: true,
                            leading: Icon(FlutterIcons.edit_fea),
                            title: Text(
                              "Edit Channel",
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.8),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditChannelMembers(
                                      widget.channelData, widget.project),
                                ),
                              ).then((value) => exitChannelSettings(value));
                            },
                            dense: true,
                            leading: Icon(FlutterIcons.user_plus_faw5s),
                            title: Text(
                              "Edit Members",
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.8),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                            enabled: loggedInUserIsOwner,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () {
                                if (loggedInUserIsOwner) {
                                  DatabaseMethods()
                                      .deleteChannel(widget.channelData['id']);
                                  exitChannelSettings(true);
                                }
                              },
                              dense: true,
                              leading: Icon(FlutterIcons.trash_alt_faw5s),
                              title: Text(
                                "Delete Channel",
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.8),
                              ),
                            )),
                      ])
              : SizedBox.shrink(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(widget.channelData['name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              subtitle: Text("Name"),
            ),
            Divider(
              thickness: 1.5,
              height: 4,
            ),
            if (widget.channelData['description'].isNotEmpty) ...[
              ListTile(
                leading: Icon(
                  FlutterIcons.info_circle_faw5s,
                  color: Colors.grey[400],
                ),
                title: Text(
                  widget.channelData['description'],
                  style: AppTheme.unSelectedTabLight.copyWith(fontSize: 15),
                ),
                subtitle: Text("Description"),
              ),
              Divider(
                thickness: 1.5,
                height: 4,
              ),
            ],
            ListTile(
              leading: Icon(
                FlutterIcons.user_friends_faw5s,
                color: Colors.grey[400],
              ),
              title: Text("${widget.channelData['members'].length} Members"),
            ),
            if (!_isLoading)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (ctx, idx) {
                    bool memberIsOwner =
                        widget.channelData['createdBy'] == members[idx].uuid;
                    bool memberIsAdmin = widget.channelData['admins']
                        .contains(members[idx].uuid);
                    return ListTile(
                      onLongPress: () {
                        if (loggedInUserIsOwner && memberIsAdmin) {
                          showDialog(
                                  context: context,
                                  builder: (ctx) => confirmationDialog(ctx,
                                      "Confirm transfer of channel ownership to ${members[idx].name}?"))
                              .then((value) {
                            if (value) {
                              widget.channelData['createdBy'] =
                                  members[idx].uuid;
                              DatabaseMethods()
                                  .updateChannel(widget.channelData);
                              exitChannelSettings(true);
                            }
                          });
                        }
                      },
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: members[idx].profilePhoto.isEmpty
                            ? AssetImage("assets/images/avatar2.jpg")
                            : NetworkImage(
                                "${ApiBaseHelper.instance.baseUrl}${members[idx].profilePhoto.substring(30)}"),
                      ),
                      title: Text(members[idx].name),
                      subtitle: Text(memberIsOwner
                          ? "owner"
                          : memberIsAdmin
                              ? "admin"
                              : "member"),
                      trailing: loggedInUserIsOwner
                          ? IconButton(
                              icon: Icon(FlutterIcons.user_cog_faw5s,
                                  color: memberIsAdmin
                                      ? kSecondaryColor
                                      : Colors.grey[400]),
                              onPressed: () {
                                setState(() {
                                  if (!memberIsOwner) {
                                    if (memberIsAdmin) {
                                      widget.channelData['admins']
                                          .remove(members[idx].uuid);
                                      _scaffoldKey.currentState
                                          .showSnackBar(new SnackBar(
                                        content: Text(
                                            "Demoted ${members[idx].name} to member"),
                                        duration: Duration(seconds: 1),
                                      ));
                                    } else {
                                      widget.channelData['admins']
                                          .add(members[idx].uuid);
                                      _scaffoldKey.currentState
                                          .showSnackBar(new SnackBar(
                                        content: Text(
                                            "Promoted ${members[idx].name} to admin"),
                                        duration: Duration(seconds: 1),
                                      ));
                                    }
                                    DatabaseMethods()
                                        .updateChannel(widget.channelData);
                                  }
                                });
                                print(widget.channelData);
                              },
                            )
                          : SizedBox.shrink(),
                    );
                  })
          ],
        ),
      ),
    );
  }
}
