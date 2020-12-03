import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/resources.dart';
// import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/ongoingResource.dart';
import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:provider/provider.dart';

import '../../style.dart';

class ResourceScreen extends StatefulWidget {
  static const routeName = "/resource-screen";

  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<Resources> listOfResources = [];
  Future resourcesFuture;
  Resources resources;
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  bool _isLoading;

  void selectOwnResource(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/own-resource-detail-screen');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          drawer: ResourceDrawer(),
          appBar: AppBar(
            leadingWidth: 35,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Resources",
                style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: SizeConfig.textMultiplier * 3,
                    fontWeight: FontWeight.w700)),
            backgroundColor: kScaffoldColor,
            elevation: 0,
          ),
          body: OngoingResource(),
        ),
      ),
      //   )
      // : Center(child: CircularProgressIndicator()),
    );
  }
}
