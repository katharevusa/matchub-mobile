import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:matchub_mobile/helpers/sdgs.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'dart:convert';
// import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/user/account-settings/change_password.dart';
import 'package:matchub_mobile/screens/user/edit-individual/edit_profile_individual.dart';
import 'package:matchub_mobile/screens/user/edit-organisation/edit_profile_organisation.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const routeName = "/user-screen";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void dismissSnackBar() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    Profile profile = Provider.of<Auth>(context).myProfile;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/avatar2.jpg"),
                  ),
                  title: Text(
                    "${profile.name}",
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text("View My Profile"),
                  onTap: () {
                    dismissSnackBar();
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(ProfileScreen.routeName,
                        arguments: Provider.of<Auth>(context).myProfile.accountId);
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
                    if (!profile.isOrgnisation) {
                    dismissSnackBar();
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      )
                          .pushNamed(EditIndividualScreen.routeName,
                              arguments: profile)
                          .then((value) {
                        if (value != null && value) {
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            key: UniqueKey(),
                            content: Text("Profile updated successfully"),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      });
                      ;
                      print("Individual");
                    } else {
                    dismissSnackBar();
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      )
                          .pushNamed(EditOrganisationScreen.routeName,
                              arguments: profile)
                          .then((value) {
                        if (value != null && value) {
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            key: UniqueKey(),
                            content: Text("Profile updated successfully"),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      });
                      print("Orgnisation");
                    }
                  }),
                  buildSettingCard(
                      "Manage Followers",
                      Icon(
                        FlutterIcons.user_friends_faw5s,
                        color: Color(0xFFf5f1da),
                      ),
                      () {}),
                  buildSettingCard(
                      "Manage Following",
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
                    onTap: () {
                    dismissSnackBar();
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(ChangePasswordScreen.routeName).then((value) {
                        if (value != null && value) {
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            content: Text("Password updated successfully"),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      });
                    },
                    leading: Icon(FlutterIcons.key_faw5s),
                    title: Text("Change Password"),
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
