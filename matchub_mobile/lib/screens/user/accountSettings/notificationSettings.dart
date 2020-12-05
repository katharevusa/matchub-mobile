import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/notificationType.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class NotificationSetting extends StatefulWidget {
  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  Profile myProfile;
  Map<String, bool> announcementSettings;
  List<String> announcementName;

  @override
  void initState() {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    announcementSettings =
        Map<String, bool>.from(myProfile.announcementsSetting);
    announcementName = announcementSettings.keys.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notification Settings"),
          actions: [
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      // title: Text('Are you sure?'),
                      content: Text("Save these changes?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No'),
                        ),
                        FlatButton(
                          onPressed: () async {
                            await ApiBaseHelper.instance.putProtected(
                                "authenticated/updateAnnouncementSettinge",
                                body: json.encode({
                                  "newSetting": announcementSettings,
                                  "userId": myProfile.accountId
                                }));
                            Provider.of<Auth>(context, listen: false)
                                .retrieveUser();
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (_, idx) {
            return ListTile(
              title: Text(
                announcementName[idx].split("_").join(" ").capitalizeWords,
              ),
              trailing: Switch(
                onChanged: (value) {
                  setState(() =>
                      announcementSettings[announcementName[idx]] = value);
                  print(announcementSettings);
                },
                value: announcementSettings[announcementName[idx]],
              ),
            );
          },
          itemCount: announcementName.length,
        ));
  }
}
