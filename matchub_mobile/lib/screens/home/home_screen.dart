import 'package:flutter/material.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(
        height:500,
        child: Column(
          children: [Text("Home Page", style:AppTheme.titleLight),
            FlatButton(child:Text("LOGOUT"), onPressed: () => Provider.of<Auth>(context).logout(),),
          ],
        ),
      )
      )
    );
  }
}