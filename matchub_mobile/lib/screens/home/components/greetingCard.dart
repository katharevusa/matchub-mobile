import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/home/leaderboard&achievement/award.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class GreetingCard extends StatefulWidget {
  @override
  _GreetingCardState createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  int noTasks = 0;

  @override
  void initState() {
    getCounter();
    super.initState();
  }

  getCounter() {
    Future.delayed(
        Duration(
          seconds: 2,
        ), () {
      noTasks = 50;
      setState(() => {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Profile myProfile = Provider.of<Auth>(context).myProfile;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 4 * SizeConfig.widthMultiplier),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome,",
                      style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          color: Colors.grey[650])),
                  Text(myProfile.name,
                      style: TextStyle(
                          fontSize: 3 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              ClipOval(
                child: Container(
                    height: 50,
                    width: 50,
                    child: AttachmentImage(
                        Provider.of<Auth>(context, listen: false)
                            .myProfile
                            .profilePhoto)),
              ),
            ],
          ),
        ),
        Stack(
          overflow: Overflow.visible,
          fit: StackFit.passthrough,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: RouteSettings(name: "/notifications"),
                    builder: (_) => Award()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 4 * SizeConfig.widthMultiplier),
                height: 17 * SizeConfig.heightMultiplier,
                width: 100 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFF086564),
                          Color(0xFF179996),
                          Color(0xFF87D6C1),
                          Color(0xFFABF4E1)
                        ])),
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 2 * SizeConfig.heightMultiplier,
                      left: 8 * SizeConfig.widthMultiplier),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("You're ranked",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: SizeConfig.heightMultiplier * 1.6,
                              letterSpacing: 1.5)),
                      SizedBox(height: 4),
                      Row(
                        children: [ 
                          Text("#",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: SizeConfig.heightMultiplier * 3,
                              letterSpacing: 1.5)),
                          Container(
                              child: AnimatedCount(
                            count: 5,
                            duration: Duration(seconds: 2),
                          )),
                        ],
                      ),
                      Text("In our Leaderboard",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: SizeConfig.heightMultiplier * 1.6,
                              letterSpacing: 1.5)),
                      Text("View Achievement >>",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 10,
              child: Container(
                height: 140,
                alignment: Alignment.centerRight,
                child: Image.asset(
                  "assets/images/homescreen.png",
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;

  AnimatedCount(
      {Key key,
      @required this.count,
      @required Duration duration,
      Curve curve = Curves.linear})
      : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _count;

  @override
  Widget build(BuildContext context) {
    return new Text(_count.evaluate(animation).toString(),
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white));
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _count = visitor(
        _count, widget.count, (dynamic value) => new IntTween(begin: value));
  }
}
