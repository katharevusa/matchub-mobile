import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/filterRequestByResource.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/incoming_request_tabview.dart';
import 'package:matchub_mobile/unused/resource_incoming_tabview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class IncomingRequestScreen extends StatefulWidget {
  static const routeName = "/resource-request-screen";
  @override
  _IncomingRequestScreenState createState() => _IncomingRequestScreenState();
}

class _IncomingRequestScreenState extends State<IncomingRequestScreen>
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
            title: Text("Incoming Request",
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
                        text: ("To my Projects"),
                      ),
                      Tab(
                        text: ("To my Resources"),
                      ),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            IncomingRequestTabview(0),
            IncomingRequestTabview(1),
          ]),
        ),
      ),
    );
  }

  /*ApiBaseHelper _helper = ApiBaseHelper.instance;
  List<ResourceRequest> listOfIncomingRequests = [];
  List<ResourceRequest> listOfIncomingPending = [];
  List<ResourceRequest> listOfIncomingApproved = [];
  List<ResourceRequest> listOfIncomingRejected = [];
  Future listOfIncomingRequestsFuture;

  @override
  void initState() {
    // listOfIncomingRequestsFuture = getAllIncomingResourceRequests();
    super.initState();
  }

/*HTTP calls*/

//   getAllIncomingResourceRequests() async {
//     var authInstance = Provider.of<Auth>(context, listen: false);
//     // final url =
//     //     'authenticated/getAllIncomingResourceRequests?userId=${profile.accountId}';

//     // final responseData = await _helper.getWODecode(
//     //     url, Provider.of<Auth>(this.context, listen: false).accessToken);
//     // (responseData as List).forEach(
//     //     (e) => listOfIncomingRequests.add(ResourceRequest.fromJson(e)));
// await Provider.of<ManageIncomingResourceRequest>(context).getAllIncomingResourceRequests(authInstance.myProfile,authInstance.accessToken);
//     // for (ResourceRequest rr in listOfIncomingRequests) {
//     //   if (rr.status == "ON_HOLD") listOfIncomingPending.add(rr);
//     //   if (rr.status == "ACCEPTED") listOfIncomingApproved.add(rr);
//     //   if (rr.status == "REJECTED") listOfIncomingRejected.add(rr);
//     // }
//   }

/*Front end methods*/

  Widget build(BuildContext context) {
    // listOfIncomingRequests =
    //     Provider.of<ManageIncomingResourceRequest>(context).listOfRequests;
    return DefaultTabController(
        length: 4,
        // child: FutureBuilder(
        //   future: listOfIncomingRequestsFuture,
        //   builder: (context, snapshot) => (snapshot.connectionState ==
        //           ConnectionState.done)
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
                              Text('  To my project'),
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
                  child: IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  FilterRequestByResourceScreen(
                                      listOfIncomingRequests)));
                    },
                  ),
                ),
              ],
            ),
            body: TabBarView(
              children: <Widget>[
                Container(
                  child: ResourceIncomingPending(
                    //listOfIncomingRequests,
                    0,
                  ),
                ),
                Container(
                  child: ResourceIncomingPending(
                    // listOfIncomingRequests,
                    1,
                  ),
                ),
                Container(
                  child: ResourceIncomingPending(
                    //listOfIncomingRequests,
                    2,
                  ),
                ),
                Container(
                  child: ResourceIncomingPending(
                    //listOfIncomingRequests,
                    3,
                  ),
                ),
              ],
            ))
        // : Center(child: CircularProgressIndicator()),

        );
  }*/
}
