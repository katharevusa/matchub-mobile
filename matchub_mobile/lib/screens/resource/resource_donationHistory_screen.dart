import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/screens/resource/navDrawer.dart';

import 'model/donationInfo.dart';

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
        drawer: NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: donationHistory.isEmpty
                ? Column(
                    children: <Widget>[
                      Text(
                        'No transactions added yet!',
                        style: Theme.of(context).textTheme.title,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: donationHistory.length,
                    itemBuilder: (context, index) {
                      // final history = donationHistory[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 4.0),
                                child: Row(children: <Widget>[
                                  Text(
                                    '\$${donationHistory[index].amount}',
                                    style: new TextStyle(fontSize: 30.0),
                                  ),
                                  Spacer(),
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 80.0),
                                child: Row(children: <Widget>[
                                  Text(
                                      "${DateFormat('dd/MM/yyyy').format(donationHistory[index].date).toString()}"),
                                  Spacer(),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )

            //child: Center(child: Text("Donation history")),
            ));
  }
}
