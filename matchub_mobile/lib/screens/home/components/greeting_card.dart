import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
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
                          fontFamily: 'Quicksand',
                          fontSize: 2 * SizeConfig.textMultiplier,
                          color: Colors.grey[650])),
                  Text(myProfile.name,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
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
            Container(
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
                        AppTheme.project4,
                        AppTheme.project4,
                      ])),
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 4 * SizeConfig.heightMultiplier,
                    left: 8 * SizeConfig.widthMultiplier),
                child: Column(
                  children: [
                    Text("NEW PROJECTS",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: SizeConfig.heightMultiplier * 1.6,
                            letterSpacing: 1.5)),
                    SizedBox(height: 4),
                    Container(
                        child: AnimatedCount(
                      count: noTasks,
                      duration: Duration(seconds: 2),
                    )),
                  ],
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
