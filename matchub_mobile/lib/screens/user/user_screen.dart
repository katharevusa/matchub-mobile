import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'dart:convert';
// import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/user/edit_profile.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const routeName = "/user-screen";
  @override
  Widget build(BuildContext context) {
    Profile profile = Profile.fromJson(json.decode(json.encode(Provider.of<Auth>(context).myProfile)));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(profile.profilePhoto),
                  ),
                  title: Text(
                    "${profile.lastName} ${profile.firstName}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text("View My Profile"),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true,).pushNamed(
                        ProfileScreen.routeName,
                        arguments: Provider.of<Auth>(context).myProfile);
                  }),
              Divider(
                thickness: 2,
              ),
              GridView.count(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5,
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  buildSettingCard("Edit Profile",
                      Icon(FlutterIcons.edit_fea, color: Color(0xFFa8e6cf)),
                      () {
                    Navigator.of(context, rootNavigator: true,).pushNamed(EditProfileScreen.routeName,
                        arguments: profile);
                  }),
                  buildSettingCard(
                      "Followers",
                      Icon(
                        FlutterIcons.user_friends_faw5s,
                        color: Color(0xFFf5f1da),
                      ),
                      () {}),
                  buildSettingCard(
                      "Following",
                      Icon(
                        FlutterIcons.user_friends_faw5s,
                        color: Color(0xFF4e89ae),
                      ),
                      () {}),
                  buildSettingCard(
                      "Announcements",
                      Icon(
                        Icons.notifications,
                        color: Color(0xFFf1d1b5),
                      ),
                      () {}),
                  buildSettingCard(
                      "Saved Projects",
                      Icon(
                        FlutterIcons.list_alt_faw5s,
                        color: Color(0xFFc3aed6),
                      ),
                      () {}),
                  buildSettingCard(
                      "Comments",
                      Icon(
                        FlutterIcons.comment_dots_faw5s,
                        color: Color(0xFFf18c8e),
                      ),
                      () {})
                ],
              ),
              ExpansionTile(
                title: Text("Notifications"),
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.notification_important),
                    title: Text("Notification Settings"),
                    subtitle: Text(
                      "Choose which notifications you want to receive",
                      style: AppTheme.subTitleLight,
                    ),
                  ),
                  ListTile(
                      onTap: () {},
                      leading: Icon(Icons.chat),
                      title: Text("Messaging Settings"),
                      subtitle: Text(
                        "Choose which messages you want to receive",
                        style: AppTheme.subTitleLight,
                      ))
                ],
              ),
              ExpansionTile(
                title: Text("Account Settings"),
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Icon(FlutterIcons.key_faw5s),
                    title: Text("Reset Password"),
                    subtitle: Text(
                      "Change your password here",
                      style: AppTheme.subTitleLight,
                    ),
                  ),
                  ListTile(
                      onTap: () {},
                      leading: Icon(FlutterIcons.security_mdi),
                      title: Text("Biometric Login"),
                      subtitle: Text(
                        "Use your fingerprint to login",
                        style: AppTheme.subTitleLight,
                      )),
                  ListTile(
                    onTap: () {
                      Provider.of<Auth>(context).logout();
                    },
                    leading: Icon(FlutterIcons.log_out_fea),
                    title: Text("Logout"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Material buildSettingCard(String setting, Icon icon, Function onTap) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(10),
            height: 10 * SizeConfig.heightMultiplier,
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  setting,
                )),
                icon,
              ],
            )),
      ),
    );
  }
}
