import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/screens/explore/explore_screen.dart';
import 'package:matchub_mobile/screens/project/project_screen.dart';
import 'package:matchub_mobile/screens/home/home_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_donationHistory_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_request_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
  get generateRoutes {
    return _TabsScreenState().generateRoute;
  }
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedPageIndex = 0;
  Future<void> _retrieveUserData;
  final Connectivity _connectivity = Connectivity();
  BuildContext context;

  // Future<void> checkConnectivity() async {
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //   ConnectivityResult result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //     if (result == ConnectivityResult.none) {
  //       Navigator.of(context)
  //           .pushReplacementNamed(NetworkErrorScreen.routeName);
  //     }
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  void initState() {
    // _retrieveUserData = fetchData();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you wish to exit MatcHub...'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() => this.context = context);
    // able to push new screen to pass arguments
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Navigator(
          initialRoute: HomeScreen.routeName,
          key: _navigatorKey,
          onGenerateRoute: generateRoute,
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (context) => HomeScreen());
          },
        ),
        bottomNavigationBar: buildBottomNavigationBar(context),
      ),
    );
  }

  void _selectPage(int index) {
    if (_selectedPageIndex == index) return;
    switch (index) {
      case 0:
        _navigatorKey.currentState.pushReplacement(
            TabRouteBuilder(builder: (context) => HomeScreen()));
        break;
      case 1:
        _navigatorKey.currentState.pushReplacement(
            TabRouteBuilder(builder: (context) => ExploreScreen()));
        break;
      case 2:
        _navigatorKey.currentState.pushReplacement(
            TabRouteBuilder(builder: (context) => ProjectScreen()));
        break;
      case 3:
        _navigatorKey.currentState.pushReplacement(
            TabRouteBuilder(builder: (context) => ResourceScreen()));
        break;
      case 4:
        _navigatorKey.currentState.pushReplacement(
            TabRouteBuilder(builder: (context) => HomeScreen()));
        break;
    }
    setState(() {
      _selectedPageIndex = index;
    });
  }

  SlideTransition standardTransition(
      context, animation, secondaryAnimation, child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      onTap: _selectPage,
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Theme.of(context).primaryColor,
      currentIndex: _selectedPageIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.home_fea),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.tasks_faw5s),
          title: Text('Explore'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          title: Text('Projects'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.briefcase_fea),
          title: Text('Resources'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.user_fea),
          title: Text('My Profile'),
        ),
      ],
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    // if (settings.name != NetworkErrorScreen.routeName) {
    //   checkConnectivity();
    // }

    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
      case ProjectScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ProjectScreen(), settings: settings);
      case ProjectScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ResourceScreen(), settings: settings);
      case ProjectScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ResourceRequestScreen(), settings: settings);
      case ProjectScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ResourceDonationHistoryScreen(),
            settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
    }
  }
}

class TabRouteBuilder<T> extends MaterialPageRoute<T> {
  TabRouteBuilder({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
