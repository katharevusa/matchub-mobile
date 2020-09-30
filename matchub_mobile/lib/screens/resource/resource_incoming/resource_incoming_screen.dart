import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/filterRequestByResource.dart';
import 'package:matchub_mobile/screens/resource/resource_incoming/resource_incoming_tabview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class IncomingRequestScreen extends StatefulWidget {
  static const routeName = "/resource-request-screen";
  @override
  _IncomingRequestScreenState createState() => _IncomingRequestScreenState();
}

class _IncomingRequestScreenState extends State<IncomingRequestScreen>
    with SingleTickerProviderStateMixin {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<ResourceRequest> listOfIncomingRequests = [];
  List<ResourceRequest> listOfIncomingPending = [];
  List<ResourceRequest> listOfIncomingApproved = [];
  List<ResourceRequest> listOfIncomingRejected = [];
  Future listOfIncomingRequestsFuture;

  @override
  void initState() {
    listOfIncomingRequestsFuture = getAllIncomingResourceRequests();
    super.initState();
  }

/*HTTP calls*/

  getAllIncomingResourceRequests() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    final url =
        'authenticated/getAllIncomingResourceRequests?userId=${profile.accountId}';

    final responseData = await _helper.getWODecode(
        url, Provider.of<Auth>(this.context, listen: false).accessToken);
    (responseData as List).forEach(
        (e) => listOfIncomingRequests.add(ResourceRequest.fromJson(e)));

    for (ResourceRequest rr in listOfIncomingRequests) {
      if (rr.status == "ON_HOLD") listOfIncomingPending.add(rr);
      if (rr.status == "ACCEPTED") listOfIncomingApproved.add(rr);
      if (rr.status == "REJECTED") listOfIncomingRejected.add(rr);
    }
  }

/*Front end methods*/

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: FutureBuilder(
        future: listOfIncomingRequestsFuture,
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? Scaffold(
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
                        listOfIncomingPending,
                        0,
                      ),
                    ),
                    Container(
                      child: ResourceIncomingPending(
                        listOfIncomingApproved,
                        1,
                      ),
                    ),
                    Container(
                      child: ResourceIncomingPending(
                        listOfIncomingRejected,
                        1,
                      ),
                    ),
                  ],
                ))
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
