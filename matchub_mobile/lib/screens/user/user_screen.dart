import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:local_auth/local_auth.dart';
import 'package:matchub_mobile/helpers/sdgs.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/follow/follow_overview.dart';
import 'dart:convert';
// import 'package:matchub_mobile/model/individual.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/user/account-settings/change_password.dart';
import 'package:matchub_mobile/screens/user/edit-individual/edit_profile_individual.dart';
import 'package:matchub_mobile/screens/user/edit-organisation/edit_profile_organisation.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  static const routeName = "/user-screen";

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void dismissSnackBar() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
  }

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  @override
  Widget build(BuildContext context) {
    Profile profile = Provider.of<Auth>(context).myProfile;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kScaffoldColor,
          elevation: 0,
          title: Text("Account",
              style: TextStyle(
                  color: Colors.grey[850],
                  fontSize: SizeConfig.textMultiplier * 3,
                  fontWeight: FontWeight.w700))),
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(height: 20),
              ListTile(
                  dense: true,
                  leading: ClipOval(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: AttachmentImage(profile.profilePhoto)),
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
                        arguments:
                            Provider.of<Auth>(context).myProfile.accountId);
                  }),
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
                    if (!profile.isOrganisation) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      )
                          .pushNamed(EditIndividualScreen.routeName,
                              arguments: profile)
                          .then((value) {
                        // dismissSnackBar();
                        if (value != null && value) {
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            key: UniqueKey(),
                            content: Text("Profile updated successfully"),
                            duration: Duration(seconds: 1),
                          ));
                          setState(() {
                            dismissSnackBar();
                            print("Individual");
                          });
                        }
                      });
                    } else {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      )
                          .pushNamed(EditOrganisationScreen.routeName,
                              arguments: profile)
                          .then((value) {
                        // dismissSnackBar();
                        if (value != null && value) {
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            key: UniqueKey(),
                            content: Text("Profile updated successfully"),
                            duration: Duration(seconds: 1),
                          ));
                          setState(() {
                            dismissSnackBar();
                            print("Organisation");
                          });
                        }
                      });
                    }
                  }),
                  buildSettingCard(
                      "Manage Following",
                      Icon(
                        FlutterIcons.user_friends_faw5s,
                        color: Color(0xFFf5f1da),
                      ), () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) =>
                          FollowOverviewScreen(user: profile, initialTab: 0),
                    ));
                  }),
                  buildSettingCard(
                      "Privacy",
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
              Theme(
                data: ThemeData(accentColor: Colors.grey),
                child: ExpansionTile(
                  title: Container(
                      child: Text(
                    "Notifications",
                  )),
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
              ),
              Theme(
                  data: ThemeData(accentColor: Colors.grey),
                  child: ExpansionTile(
                    title: Text("Account Settings"),
                    children: [
                      ListTile(
                        onTap: () {
                          dismissSnackBar();
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          )
                              .pushNamed(ChangePasswordScreen.routeName)
                              .then((value) {
                            if (value != null && value) {
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                key: UniqueKey(),
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
                          trailing: Switch(
                            value: Provider.of<Auth>(context).biometricsEnabled,
                            onChanged: (value) async {
                              bool authenticated = false;
                              if (value) {
                                try {
                                  _canCheckBiometrics =
                                      await auth.canCheckBiometrics;
                                  _availableBiometrics =
                                      await auth.getAvailableBiometrics();

                                  authenticated =
                                      await auth.authenticateWithBiometrics(
                                          localizedReason:
                                              'Use your biometrics to verify your identity',
                                          useErrorDialogs: true,
                                          stickyAuth: false);
                                } on PlatformException catch (e) {
                                  print(e);
                                  return;
                                }
                                if (!mounted) return;
                              }

                              await Provider.of<Auth>(context)
                                  .setBiometricLogin(authenticated);
                              setState(() {
                                print("Set biometrics: " + value.toString());
                              });
                            },
                            // activeTrackColor: Colors.lightGreenAccent,
                            activeColor: kSecondaryColor,
                          ),
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
                  ))
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
