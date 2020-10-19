import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/navigation/navigation.dart';
import 'package:matchub_mobile/screens/home/home_screen.dart';
// import 'package:matchub_mobile/screens/login/auth_screen.dart';
import 'package:matchub_mobile/screens/login/login_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageOrganisationMembers.dart';
import 'package:matchub_mobile/services/manage_listOfKah.dart';
import 'package:matchub_mobile/services/manage_notification.dart';
import 'package:matchub_mobile/services/manage_outgoingRequest.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/services/manage_resource.dart';
import 'package:matchub_mobile/services/notification_service.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'services/kanban_controller.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  ApiBaseHelper api = ApiBaseHelper();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Auth()),
            ChangeNotifierProvider(create: (_) => Profile()),
            ChangeNotifierProvider(create: (_) => ManageProject()),
            ChangeNotifierProvider(create: (_) => ManageOrganisationMembers()),
            ChangeNotifierProvider(create: (_) => ManageListOfKah()),
            ChangeNotifierProvider(create: (_) => ManageResource()),
            ChangeNotifierProvider(create: (_) => ManageOutgoingRequest()),
            ChangeNotifierProvider(create: (_) => ManageNotification()),
            ChangeNotifierProvider(create: (_) => KanbanController()),
          ],
          child: Consumer<Auth>(
            builder: (context, auth, widget) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MatcHub',
              theme: AppTheme.lightTheme,
              home: auth.isAuth
                  ? ChangeNotifierProvider(
                      create: (_) => NotificationService(auth.myProfile.uuid),
                      child: TabsScreen())
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) => LoginScreen(),
                    ),
              onGenerateRoute: TabsScreen().generateRoutes,
              onUnknownRoute: (settings) {
                return MaterialPageRoute(builder: (context) => TabsScreen());
              },
            ),
          ),
        );
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
