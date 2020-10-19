import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
// import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';
import 'package:matchub_mobile/unused/resource_incoming_tabview.dart';
import 'package:matchub_mobile/screens/resource/resource_outgoing/OutgoingRequestTabview.dart';
import 'package:matchub_mobile/unused/resource_outgoing_tabview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class OutgoingRequestScreen extends StatefulWidget {
  // static const routeName = "/resource-request-screen";//
  @override
  _OutgoingRequestScreenState createState() => _OutgoingRequestScreenState();
}

class _OutgoingRequestScreenState extends State<OutgoingRequestScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          drawer: ResourceDrawer(),
          // endDrawer: DrawerMenu(),
          appBar: AppBar(
            leadingWidth: 35,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Outgoing Request",
                style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: SizeConfig.textMultiplier * 3,
                    fontWeight: FontWeight.w700)),
            backgroundColor: kScaffoldColor,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: TabBar(
                    labelColor: Colors.grey[600],
                    unselectedLabelColor: Colors.grey[400],
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 4,
                          color: kSecondaryColor,
                        ),
                        insets: EdgeInsets.only(left: 8, right: 8, bottom: 4)),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: ("To other Projects"),
                      ),
                      Tab(
                        text: ("To other Resources"),
                      ),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            OutgoingRequestTabview(0),
            OutgoingRequestTabview(1),
          ]),
        ),
      ),
    );
  }

/*HTTP calls*/

  // getAllOutgingResourceRequests() async {
  //   Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
  //   final url =
  //       'authenticated/getAllOutgoingDonationRequests?userId=${profile.accountId}';

  //   final responseData = await _helper.getWODecode(
  //       url, Provider.of<Auth>(this.context, listen: false).accessToken);
  //   (responseData as List).forEach(
  //       (e) => listOfOutgoingRequests.add(ResourceRequest.fromJson(e)));

  //   for (ResourceRequest rr in listOfOutgoingRequests) {
  //     if (rr.status == "ON_HOLD") listOfOutgoingPending.add(rr);
  //     if (rr.status == "ACCEPTED") listOfOutgoingApproved.add(rr);
  //     if (rr.status == "REJECTED") listOfOutgoingRejected.add(rr);
  //   }
  // }

/*Front end methods*/
  /* Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            drawer: ResourceDrawer(),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.blueGrey.shade800,
              bottom: PreferredSize(
                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.3),
                      indicatorColor: Color(0xffE70F0B),
                      labelColor: Color(0xffE70F0B),
                      tabs: [
                        Tab(
                          icon: Row(
                            children: [
                              Text('  Pending'),
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            children: [
                              Text('  Approved'),
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            children: [
                              Text('  Rejected'),
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            children: [
                              Text('  Expired'),
                            ],
                          ),
                        ),
                      ]),
                  preferredSize: Size.fromHeight(40.0)),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.search),
                ),
              ],
            ),
            body: TabBarView(
              children: <Widget>[
                Container(
                  child: ResourceOutgoingPending(
                    0,
                  ),
                ),
                Container(
                  child: ResourceOutgoingPending(
                    1,
                  ),
                ),
                Container(
                  child: ResourceOutgoingPending(
                    2,
                  ),
                ),
                Container(
                  child: ResourceOutgoingPending(
                    3,
                  ),
                ),
              ],
            )));
  }*/
}
