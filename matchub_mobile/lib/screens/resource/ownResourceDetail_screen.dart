import 'package:flutter/material.dart';
import 'package:matchub_mobile/model/resource.dart';
import 'package:matchub_mobile/screens/resource/resource_creation_screen.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';

class OwnResourceDetailScreen extends StatefulWidget {
  static const routeName = "/own-resource-detail";

  @override
  _OwnResourceDetailScreenState createState() =>
      _OwnResourceDetailScreenState();
}

class _OwnResourceDetailScreenState extends State<OwnResourceDetailScreen>
    with TickerProviderStateMixin {
  double screenSize;

  double screenRatio;

  AppBar appBar;

  List<Tab> tabList = List();

  TabController _tabController;

  @override
  void initState() {
    tabList.add(new Tab(
      text: 'Description',
    ));
    tabList.add(new Tab(
      text: 'Projects',
    ));
    _tabController = new TabController(vsync: this, length: tabList.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Resource resource = ModalRoute.of(context).settings.arguments;

    screenSize = MediaQuery.of(context).size.width;
    appBar = AppBar(
      title: Text(resource.title),
      elevation: 0.0,
    );

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/resource.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text("Resources"),
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: screenSize,
                      // decoration: new BoxDecoration(
                      //   image: new DecorationImage(
                      //     image: new AssetImage("assets/images/resource.png"),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                    ),
                    new Text(
                      '* * * *',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Colors.pink),
                    ),
                    new Text(resource.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0)),
                    TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.pink,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: tabList),
                  ],
                ),
                preferredSize: Size.fromHeight(200))),
        body: TabBarView(controller: _tabController, children: [
          Container(
            //  padding: EdgeInsets.all(3.0),
            width: screenSize,

            child: Description(),
          ),
          Container(
            child: MatchedProjects(),
          ),
        ]),
      ),
    );
  }
}

class Description extends StatefulWidget {
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      padding: EdgeInsets.all(20),
      // height: 29 * SizeConfig.heightMultiplier,
      width: 100 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 3),
              blurRadius: 10,
              color: kSecondaryColor.withOpacity(0.1),
            ),
            BoxShadow(
              offset: Offset(-4, -3),
              blurRadius: 10,
              color: kSecondaryColor.withOpacity(0.1),
            ),
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Column(),

      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     if (profile.country != null)
      //       Row(
      //         children: [
      //           Expanded(child: Text("Based In")),
      //           if (profile.city != null)
      //             Text("${profile.city}, ", style: AppTheme.subTitleLight),
      //           Text("${profile.country}", style: AppTheme.subTitleLight)
      //         ],
      //       ),
      //     SizedBox(height: 10),
      //     //buildSDGTags(),
      //     SizedBox(height: 10),
      //    // buildSkillset(),
      //     SizedBox(height: 10),
      //    // buildProfileUrl(),
      //     SizedBox(height: 10),
      //     Column(
      //       children: [
      //         Row(
      //           children: [Expanded(child: Text("Description"))],
      //         ),
      //         Row(
      //           children: [Expanded(child: Text(profile.profileDescription,
      //             style: AppTheme.unSelectedTabLight))],
      //         )
      //       ],
      //     )
      //   ],
      // )
    );
    //   return SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Text(
    //             "owadays, makiowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have owadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yobecome fast, easy and simple. If yoowadays, making printed materials have become fast, easy and simple. If yong printed materials have become fast, easy and simple. If you want your promotional material to be an eye-catching object, you should make it colored. By way of using inkjet printer this is not hard to make. An inkjet printer is any printer that places extremely small droplets of ink onto paper to create an image.Nowadays, making printed materials have become fast, easy and simple. If you want your promotional material to be an eye-catching object, you should make it colored. By way of using inkjet printer this is not hard to make. An inkjet printer is any printer that places extremely small droplets of ink onto paper to create an image.Nowadays, making printed materials have become fast, easy and simple. If you want your promotional material to be an eye-catching object, you should make it colored. By way of using inkjet printer this is not hard to make. An inkjet printer is any printer that places extremely small droplets of ink onto paper to create an image.Nowadays, making printed materials have become fast, easy and simple. If you want your promotional material to be an eye-catching object, you should make it colored. By way of using inkjet printer this is not hard to make. An inkjet printer is any printer that places extremely small droplets of ink onto paper to create an image.Nowadays, making printed materials have become fast, easy and simple. If you want your promotional material to be an eye-catching object, you should make it colored. By way of using inkjet printer this is not hard to make. An inkjet printer is any printer that places extremely small droplets of ink onto paper to create an image.Nowadays, making printed materials have become fast, easy and simple. If you want your promotional material to be an eye-catching object, you should make it colored. By way of using inkjet printer this is not hard to make. An inkjet printer is any printer that places extremely small droplets of ink onto paper to create an image."),
    //       ],
    //     ),
    //   );
    // }
// }
  }
}

class MatchedProjects extends StatefulWidget {
  _MatchedProjectsState createState() => _MatchedProjectsState();
}

class _MatchedProjectsState extends State<MatchedProjects> {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Project")));
  }
}
