import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import 'channel_creation.dart';
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
  @override
  initState() {
    _isLoading = true;
    getMembersDetails();
    super.initState();
  }

  getMembersDetails() async {
    for (String uuid in widget.channelData['members']) {
      final response = await ApiBaseHelper().getProtected(
          "authenticated/getAccountByUUID/$uuid",
          Provider.of<Auth>(context, listen: false).accessToken);
      members.add(Profile.fromJson(response));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Channel Info"),
        actions: [
          PopupMenuButton(
              offset: Offset(0, 50),
              icon: Icon(
                FlutterIcons.ellipsis_v_faw5s,
                size: 20,
                color: Colors.white,
              ),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditChannel(
                                widget.channelData,
                              ),
                            ),
                          );
                          Navigator.of(context)
                              .popUntil(ModalRoute.withName("/"));
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
                        onTap: () {},
                        dense: true,
                        leading: Icon(FlutterIcons.trash_alt_faw5s),
                        title: Text(
                          "Delete Chat",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditChannelMembers(
                                  widget.channelData, widget.project),
                            ),
                          ).then((value) {
                            print("==============");
                            print(value);
                            if (value != null && value) {
                              Navigator.of(context)
                                  .popUntil(ModalRoute.withName("/"));
                            }
                          });
                        },
                        dense: true,
                        leading: Icon(FlutterIcons.user_plus_faw5s),
                        title: Text(
                          "Edit Members",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                      ),
                    )
                  ]),
          // IconButton(
          //   alignment: Alignment.bottomCenter,
          //   visualDensity: VisualDensity.comfortable,
          //   icon: Icon(
          //     FlutterIcons.ellipsis_v_faw5s,
          //     size: 20,
          //     color: Colors.grey[800],
          //   ),
          //   onPressed: () => showModalBottomSheet(
          //           context: context,
          //           builder: (context) => buildMorePopUp(context))
          //       .then((value) => setState(() {
          //             loadProject = getProjects();
          //           })),
          // ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.channelData['name']),
            subtitle: Text("Name"),
          ),
          Divider(
            thickness: 1.5,
          ),
          ListTile(
            leading: Icon(
              FlutterIcons.info_circle_faw5s,
              color: Colors.grey[400],
            ),
            title: Text(
              widget.channelData['description'],
              style: AppTheme.unSelectedTabLight,
            ),
            subtitle: Text("Description"),
          ),
          Divider(
            thickness: 1.5,
          ),
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
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: members[idx].profilePhoto.isEmpty
                          ? AssetImage("assets/images/avatar2.jpg")
                          : NetworkImage(
                              "${ApiBaseHelper().baseUrl}${members[idx].profilePhoto.substring(30)}"),
                    ),
                    title: Text(members[idx].name),
                    subtitle: Text(
                        widget.channelData['admins'].contains(members[idx].uuid)
                            ? "admin"
                            : "member"),
                  );
                })
        ],
      ),
    );
  }
}
