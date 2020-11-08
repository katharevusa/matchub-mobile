import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/screens/home/leaderboard&achievement/ranking.dart';

import '../../sizeconfig.dart';
import 'components/create_post.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => CreatePostScreen(),
                      fullscreenDialog: true),
                );
              },
              child: Container(
                width: 100 * SizeConfig.widthMultiplier,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey[200].withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                    color: Colors.white),
                child: Center(
                    child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text("What's on your mind...",
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14))),
                    Icon(FlutterIcons.edit_faw5, color: Colors.grey[400]),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )),
              ),
            ),
          ),
          Ranking(),
        ],
      ),
    );
  }
}
