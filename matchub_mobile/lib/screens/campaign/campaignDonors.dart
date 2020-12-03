import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/profileHelper.dart';
import 'package:matchub_mobile/models/index.dart';

import '../../style.dart';

class ViewCampaignDonors extends StatefulWidget {
  ViewCampaignDonors({this.campaign});
  Campaign campaign;

  @override
  _ViewCampaignDonorsState createState() => _ViewCampaignDonorsState();
}

class _ViewCampaignDonorsState extends State<ViewCampaignDonors> {
  List<Donation> allDonations = [];
  bool isLoading;
  @override
  void initState() {
    retrieveDonations();
    super.initState();
  }

  retrieveDonations() async {
    setState(() => isLoading = true);
    final url =
        'authenticated/getAllDonationsByCampaignId?fundCampaignId=${widget.campaign.fundsCampaignId}';
    final responseData = await ApiBaseHelper.instance.getWODecode(url);
    (responseData as List)
        .forEach((e) => allDonations.add(Donation.fromJson(e)));
        allDonations.sort((a,b)=> b.donationTime.compareTo(a.donationTime));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("All Campaign Donors")),
        // body: GridView.builder(
        //   shrinkWrap: true,
        //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        //   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        //       mainAxisSpacing: 10,
        //       crossAxisSpacing: 10,
        //       childAspectRatio: 0.8,
        //       crossAxisCount: 3),
        //   itemCount: allDonations.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Container(
        //       decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(15),
        //           boxShadow: [
        //             BoxShadow(
        //                 color: Colors.grey[400].withOpacity(0.3),
        //                 spreadRadius: 2,
        //                 blurRadius: 3,
        //                 offset: Offset(0, 0)),
        //           ]),
        //       padding: const EdgeInsets.symmetric(vertical: 10),
        //       height: 80,
        //       child: Column(
        //         children: [
        //           buildAvatar(allDonations[index].donator),
        //           SizedBox(height: 10),
        //           Text(allDonations[index].donator.name,
        //               maxLines: 1,
        //               style: TextStyle(
        //                   fontSize: 15,
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.grey[850])),
        //           SizedBox(height: 5),
        //           Text(
        //               "S\$${allDonations[index].donatedAmount.toStringAsFixed(2)}",
        //               style: TextStyle(color: kKanbanColor)),
        //           SizedBox(height: 5),
        //           Text(DateFormat.yMMMd()
        //               .format(allDonations[index].donationTime),
        //               style: AppTheme.subTitleLight),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        body: ListView.builder(
            itemCount: allDonations.length,
            itemBuilder: (BuildContext context, int index) => ListTile(
                  leading: buildAvatar(allDonations[index].donator),
                  title: Text(allDonations[index].donator.name,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[850])),
                  subtitle: Text(
                      DateFormat.yMMMd().add_jm()
                          .format(allDonations[index].donationTime),
                      style: AppTheme.subTitleLight),
                  trailing: Text(
                      "S\$${allDonations[index].donatedAmount.toStringAsFixed(2)}",
                      style: TextStyle(color: kKanbanColor)),
                )));
  }
}
