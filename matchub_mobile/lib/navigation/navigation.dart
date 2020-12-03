import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/navigation/explore_navigator.dart';
import 'package:matchub_mobile/navigation/profile_navigator.dart';
import 'package:matchub_mobile/navigation/resource_navigator.dart';
import 'package:matchub_mobile/screens/chat/chatScreen.dart';
import 'package:matchub_mobile/screens/follow/follow_overview.dart';
import 'package:matchub_mobile/screens/home/components/create_post.dart';
import 'package:matchub_mobile/screens/kanban/task/viewTask.dart';
import 'package:matchub_mobile/screens/profile/view_profile.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/user/select_targets.dart';
import 'package:matchub_mobile/unused/project_screen.dart';
import 'package:matchub_mobile/screens/home/home_screen.dart';
import 'package:matchub_mobile/screens/project_management/notification/announcementDetail.dart';
import 'package:matchub_mobile/screens/project_management/project_management.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_donationHistory_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/resource_incoming_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_screen.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/login/reset_password.dart';
import 'package:matchub_mobile/screens/login/register_screen.dart';
import 'package:matchub_mobile/screens/search/search_page.dart';
import 'package:matchub_mobile/screens/user/account-settings/change_password.dart';
import 'package:matchub_mobile/screens/user/edit-individual/edit_profile_individual.dart';
import 'package:matchub_mobile/screens/user/edit-organisation/edit_profile_organisation.dart';
import 'package:matchub_mobile/screens/user/user_screen.dart';
import 'package:matchub_mobile/widgets/resourceCategoryPicker.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';
import './project_navigator.dart';
import 'home_navigator.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
  get generateRoutes {
    return _TabsScreenState().generateRoute;
  }
}

class _TabsScreenState extends State<TabsScreen> {
  // List<Map<String, Object>> _pages;
  // final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedPageIndex = 0;
  // Future<void> _retrieveUserData;
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

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    bookNavigatorKey1,
    exploreNavigatorKey,
    projectNavigatorKey,
    resourceNavigatorKey,
    profileNavigatorKey,
  ];

  Future<bool> _systemBackButtonPressed() async {
    if (_navigatorKeys[_selectedPageIndex].currentState.canPop()) {
      _navigatorKeys[_selectedPageIndex]
          .currentState
          .pop(_navigatorKeys[_selectedPageIndex].currentContext);
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you wish to exit MatcHub...'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() => this.context = context);
    // able to push new screen to pass arguments
    return WillPopScope(
      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        // body: Navigator(
        //   initialRoute: HomeScreen.routeName,
        //   key: _navigatorKey,
        //   onGenerateRoute: generateRoute,
        //   onUnknownRoute: (settings) {
        //     return MaterialPageRoute(builder: (context) => HomeScreen());
        //   },
        // ),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedPageIndex,
            children: <Widget>[
              HomeNavigator(),
              ExploreNavigator(),
              ProjectNavigator(),
              ResourceNavigator(),
              ProfileNavigator(),
            ],
          ),
        ),
        bottomNavigationBar: buildBottomNavigationBar(context),
      ),
    );
  }

  // void _selectPage(int index) {
  // if (_selectedPageIndex == index) return;
  // switch (index) {
  //   case 0:
  //     _navigatorKey.currentState.pushReplacement(
  //         TabRouteBuilder(builder: (context) => ChatScreen()));
  //     break;
  //   case 1:
  //     _navigatorKey.currentState.pushReplacement(
  //         TabRouteBuilder(builder: (context) => ExploreScreen()));
  //     break;
  //   case 2:
  //     _navigatorKey.currentState.pushReplacement(
  //         TabRouteBuilder(builder: (context) => ProjectOverview()));
  //     break;
  //   case 3:
  //     _navigatorKey.currentState.pushReplacement(
  //         TabRouteBuilder(builder: (context) => ResourceScreen()));
  //     break;
  //   case 4:
  //     _navigatorKey.currentState.pushReplacement(
  //         TabRouteBuilder(builder: (context) => UserScreen()));
  //     break;
  // }

  // }

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
      onTap: (index) {
        setState(() {
          _selectedPageIndex = index;
        });
      },
      // backgroundColor: Colors.white,
      // unselectedItemColor: Colors.grey,
      // selectedItemColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.blueGrey[800],
      unselectedItemColor: Colors.blueGrey[300],
      selectedItemColor: Colors.white,
      currentIndex: _selectedPageIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.home_fea),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.inbox_fea),
          title: Text('Inbox'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.tasks_faw5s),
          title: Text('Projects'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.briefcase_fea),
          title: Text('Resources'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.user_fea),
          title: Text('Profile'),
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
      case CreatePostScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => CreatePostScreen(), settings: settings);
      case ResourceScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ResourceScreen(), settings: settings);
      case ResourceScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => IncomingRequestScreen(), settings: settings);
      case ResourceScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ResourceDonationHistoryScreen(),
            settings: settings);
      case SDGPicker.routeName:
        return MaterialPageRoute(
            builder: (context) => SDGPicker(), settings: settings);
      case ProfileScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  accountId: settings.arguments as int,
                ),
            settings: settings);
      case ViewProfile.routeName:
        return MaterialPageRoute(
            builder: (context) => ViewProfile(
                  accountId: settings.arguments as int,
                ),
            settings: settings);
      case EditIndividualScreen.routeName:
        return MaterialPageRoute(
            builder: (context) =>
                EditIndividualScreen(profile: settings.arguments as Profile),
            fullscreenDialog: true,
            settings: settings);
      case ChangePasswordScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(), settings: settings);
      case ResetPassword.routeName:
        return MaterialPageRoute(
            builder: (context) => ResetPassword(), settings: settings);
      case ResourceCategoryPicker.routeName:
        return MaterialPageRoute(
            builder: (context) => ResourceCategoryPicker(
                  categories: settings.arguments as List,
                ),
            settings: settings);
      case FollowOverviewScreen.routeName:
        final user =
            (settings.arguments as Map<String, dynamic>)['profile'] as Profile;
        final initialTab =
            (settings.arguments as Map<String, dynamic>)['initialTab'] as int;
        return MaterialPageRoute(
            builder: (context) =>
                FollowOverviewScreen(user: user, initialTab: initialTab),
            settings: settings);
      case EditOrganisationScreen.routeName:
        return MaterialPageRoute(
            builder: (context) =>
                EditOrganisationScreen(profile: settings.arguments as Profile),
            fullscreenDialog: true,
            settings: settings);
      case ChangePasswordScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(), settings: settings);
      case RegisterScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => RegisterScreen(), settings: settings);
      case FollowOverviewScreen.routeName:
        final user =
            (settings.arguments as Map<String, dynamic>)['profile'] as Profile;
        final initialTab =
            (settings.arguments as Map<String, dynamic>)['initialTab'] as int;
        return MaterialPageRoute(
            builder: (context) =>
                FollowOverviewScreen(user: user, initialTab: initialTab),
            settings: settings);
      case UserScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => UserScreen(), settings: settings);
      case ProjectDetailScreen.routeName:
        return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => ProjectDetailScreen(
                  project: settings.arguments as Project,
                ),
            settings: settings);
      case ResourceDetailScreen.routeName:
        return MaterialPageRoute(
            builder: (context) =>
                ResourceDetailScreen(settings.arguments as Resources),
            // fullscreenDialog: true,
            settings: settings);

      case AnnouncementDetail.routeName:
        return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => AnnouncementDetail(
                  announcement: settings.arguments as Announcement,
                ),
            settings: settings);

      case ProjectManagementOverview.routeName:
        return MaterialPageRoute(
            builder: (context) =>
                ProjectManagementOverview(settings.arguments as Project),
            settings: settings);
      case SearchResults.routeName:
        return MaterialPageRoute(
            builder: (context) => SearchResults(), settings: settings);
      case ProjectManagementOverview.routeName:
        return MaterialPageRoute(
            builder: (context) =>
                ProjectManagementOverview(settings.arguments as Project),
            settings: settings);
      case ViewTask.routeName:
        return MaterialPageRoute(
            builder: (
              context,
            ) =>
                ViewTask(task: settings.arguments as TaskEntity),
            settings: settings,
            fullscreenDialog: true);
      case SearchResults.routeName:
        return MaterialPageRoute(
            builder: (context) => SearchResults(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
    }
  }
}

//Animation with no Fade
class TabRouteBuilder<T> extends MaterialPageRoute<T> {
  TabRouteBuilder({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
