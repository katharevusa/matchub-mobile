import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matchub_mobile/navigation.dart';
import 'package:matchub_mobile/screens/home/home_screen.dart';
import 'package:matchub_mobile/screens/login/auth_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

void main() {
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
          ],
          child: Consumer<Auth>(
            builder: (context, auth, widget) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MatcHub',
              theme: AppTheme.lightTheme,
              home: TabsScreen(),
              // auth.isAuth
              //     ?  TabsScreen()
              //     : FutureBuilder(
              //         future: auth.tryAutoLogin(),
              //         builder: (ctx, authResultSnapshot) => LoginScreen(),
              //       ),
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
