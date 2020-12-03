import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/models/donationInfo.dart';
// import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/resource_drawer.dart';

class ResourceDonationHistoryScreen extends StatefulWidget {
  static const routeName = "/resource-request-screen";
  @override
  _ResourceDonationHistoryScreenState createState() =>
      _ResourceDonationHistoryScreenState();
}

class _ResourceDonationHistoryScreenState
    extends State<ResourceDonationHistoryScreen> {
  final List<DonationInfo> donationHistory = [
    new DonationInfo(title: "Test1", amount: 30, date: DateTime.now()),
    new DonationInfo(title: "Test2", amount: 50, date: DateTime.now()),
    new DonationInfo(title: "Test3", amount: 80, date: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: ResourceDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
        ),
        body: Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: donationHistory.length,
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
                                      donationHistory[index].title,
                                      style: new TextStyle(fontSize: 30.0),
                                    ),
                                    Spacer(),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 80.0),
                                  child: Row(children: <Widget>[
                                    Text(DateFormat('dd/MM/yyyy')
                                        .format(donationHistory[index].date)
                                        .toString()),
                                    Spacer(),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        donationHistory[index]
                                            .amount
                                            .toString(),
                                        style: new TextStyle(fontSize: 35.0),
                                      ),
                                      Spacer(),
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
            ])));
  }
}
