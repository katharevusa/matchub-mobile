import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
// import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/resource_incoming_tabview.dart';
import 'package:matchub_mobile/screens/resource/resource_outgoing/resource_outgoing_tabview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class OutgoingRequestScreen extends StatefulWidget {
  // static const routeName = "/resource-request-screen";//
  @override
  _OutgoingRequestScreenState createState() => _OutgoingRequestScreenState();
}

class _OutgoingRequestScreenState extends State<OutgoingRequestScreen>
    with SingleTickerProviderStateMixin {
  // ApiBaseHelper _helper = ApiBaseHelper();
  // List<ResourceRequest> listOfOutgoingRequests = [];
  // List<ResourceRequest> listOfOutgoingPending = [];
  // List<ResourceRequest> listOfOutgoingApproved = [];
  // List<ResourceRequest> listOfOutgoingRejected = [];
  // Future listOfOutgoingRequestsFuture;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                              Icon(FlutterIcons.library_books_mco),
                              Text('  Pending'),
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            children: [
                              Icon(FlutterIcons.tasks_faw5s),
                              Text('  Approved'),
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            children: [
                              Icon(FlutterIcons.briefcase_fea),
                              Text('  Rejected'),
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
              ],
            )));
  }
}
