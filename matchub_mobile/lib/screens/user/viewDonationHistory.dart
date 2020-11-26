import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../style.dart';

class ViewDonationHistory extends StatefulWidget {
  @override
  _ViewDonationHistoryState createState() => _ViewDonationHistoryState();
}

class _ViewDonationHistoryState extends State<ViewDonationHistory> {
  List<Donation> userDonations = [];
  bool isLoading;
  @override
  void initState() {
    retrieveDonations();
    super.initState();
  }

  retrieveDonations() async {
    setState(() => isLoading = true);
    final url =
        'authenticated/getPastDonationsByUserId?userId=${Provider.of<Auth>(context, listen: false).myProfile.accountId}';
    final responseData = await ApiBaseHelper.instance.getWODecode(url);
    (responseData as List)
        .forEach((e) => userDonations.add(Donation.fromJson(e)));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Backed Campaigns")),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TimelineTile(
                        isFirst: index == 0,
                        isLast: index == userDonations.length - 1,
                        alignment: TimelineAlign.manual,
                        indicatorStyle: IndicatorStyle(
                            padding: EdgeInsets.symmetric(horizontal: 8)),
                        lineXY: 0.27,
                        startChild: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: Center(
                              child: Column(children: [
                                SizedBox(height: 10),
                                Text(
                                  "Today at ${DateFormat("HH:mm aaa").format(userDonations[index].donationTime)}",
                                  style: AppTheme.selectedTabLight,
                                )
                              ]),
                            )),
                        endChild: Material(
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Donated \$${userDonations[index].donatedAmount}",
                                    style: AppTheme.titleLight
                                        .copyWith(color: kPrimaryColor),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Campaign Title: ",
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: 12),
                                      ),
                                      Text(
                                        " ${userDonations[index].donationOption.fundCampaign.campaignTitle}",
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Option: ",
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${userDonations[index].donationOption.optionDescription}",
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: 14),
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                itemCount: userDonations.length));
  }
}
