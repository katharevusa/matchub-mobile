import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/resource/resource_drawer.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class ResourceDonationHistoryScreen extends StatefulWidget {
  static const routeName = "/resource-request-screen";
  @override
  _ResourceDonationHistoryScreenState createState() =>
      _ResourceDonationHistoryScreenState();
}

class _ResourceDonationHistoryScreenState
    extends State<ResourceDonationHistoryScreen>
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
          appBar: AppBar(
            leadingWidth: 35,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Resource Payment History",
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
                        text: ("Resource Payment Received"),
                      ),
                      Tab(
                        text: ("Resource Payment Made"),
                      ),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            Container(
              child: ResourceTransactionMade(),
            ),
            // Container(
            //   child: ExpiredResource(listOfResources),
            // ),
            Container(
              child: ConsumedResourceTransaction(),
            ),
          ]),
        ),
      ),
      //   )
      // : Center(child: CircularProgressIndicator()),
    );
  }
}

class ResourceTransactionMade extends StatefulWidget {
  @override
  _ResourceTransactionMadeState createState() =>
      _ResourceTransactionMadeState();
}

class _ResourceTransactionMadeState extends State<ResourceTransactionMade> {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  List<ResourceTransaction> transactionsMade = [];
  @override
  void initState() {
    super.initState();
  }

  getAllTransactionsRecieved() async {
    transactionsMade = [];
    Profile profile = Provider.of<Auth>(context).myProfile;
    final url =
        'authenticated/getResourceTransactionForOwnedResources?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => transactionsMade.add(ResourceTransaction.fromJson(e)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllTransactionsRecieved(),
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Container(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: transactionsMade.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Row(children: <Widget>[
                                        Text(
                                          'Resource',
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          transactionsMade[index]
                                              .resource
                                              .resourceName,
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Row(children: <Widget>[
                                        Text(
                                          'Amount',
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          transactionsMade[index]
                                                  .resource
                                                  .units
                                                  .toString() +
                                              " Units",
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  'Project paired to',
                                                  style: new TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              transactionsMade[index]
                                                  .project
                                                  .projectTitle,
                                              style:
                                                  new TextStyle(fontSize: 15.0),
                                            ),
                                          ]),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Row(children: <Widget>[
                                        Text(
                                          'Transaction Date',
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(transactionsMade[index]
                                                  .transactionTime)
                                              .toString(),
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Total",
                                            style: new TextStyle(
                                                fontSize: 30.0,
                                                color: Colors.black),
                                          ),
                                          Spacer(),
                                          Text(
                                            '\$' +
                                                transactionsMade[index]
                                                    .amountPaid
                                                    .toString() +
                                                '0',
                                            style: new TextStyle(
                                                fontSize: 30.0,
                                                color: AppTheme.project4),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ]))
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ConsumedResourceTransaction extends StatefulWidget {
  @override
  _ConsumedResourceTransactionState createState() =>
      _ConsumedResourceTransactionState();
}

class _ConsumedResourceTransactionState
    extends State<ConsumedResourceTransaction> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  List<ResourceTransaction> consumedResources = [];
  Future loader;

  @override
  void initState() {
    super.initState();
  }

  getAllConsumedResources() async {
    consumedResources = [];
    Profile profile = Provider.of<Auth>(context).myProfile;
    final url =
        'authenticated/getResourceTransactionForConsumedResources?userId=${profile.accountId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => consumedResources.add(ResourceTransaction.fromJson(e)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllConsumedResources(),
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Container(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: consumedResources.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Row(children: <Widget>[
                                        Text(
                                          'Resource',
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          consumedResources[index]
                                              .resource
                                              .resourceName,
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Row(children: <Widget>[
                                        Text(
                                          'Amount',
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          consumedResources[index]
                                                  .resource
                                                  .units
                                                  .toString() +
                                              " Units",
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  'Project paired to',
                                                  style: new TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              consumedResources[index]
                                                  .project
                                                  .projectTitle,
                                              style:
                                                  new TextStyle(fontSize: 15.0),
                                            ),
                                          ]),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Row(children: <Widget>[
                                        Text(
                                          'Transaction Date',
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(consumedResources[index]
                                                  .transactionTime)
                                              .toString(),
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Total",
                                            style: new TextStyle(
                                                fontSize: 30.0,
                                                color: Colors.black),
                                          ),
                                          Spacer(),
                                          Text(
                                            '\$' +
                                                consumedResources[index]
                                                    .amountPaid
                                                    .toString() +
                                                '0',
                                            style: new TextStyle(
                                                fontSize: 30.0,
                                                color: AppTheme.project4),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ]))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
