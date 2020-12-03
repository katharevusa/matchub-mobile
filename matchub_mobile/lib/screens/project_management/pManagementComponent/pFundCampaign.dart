import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/campaign/campaign_creation.dart';
import 'package:matchub_mobile/screens/campaign/view_all_campaigns.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/campaignCard.dart';
import 'package:provider/provider.dart';

class PFundCampaignCard extends StatelessWidget {
  Project project;
  num totalFund = 0;
  num totalTarget = 0;
  @override
  Widget build(BuildContext context) {
    project = Provider.of<ManageProject>(context).managedProject;
    for (Campaign c in project.fundsCampaign) {
      totalFund += c.currentAmountRaised;
      totalTarget += c.campaignTarget;
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PFundCampaignList()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: AppTheme.project6.withOpacity(0.4),
          // shadowColor: AppTheme.project4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Container(
                      // padding: EdgeInsets.only(top: 15, bottom: 5),
                      child: Text("Fund Campaign",
                          style: TextStyle(color: Colors.white, fontSize: 15))),
                  Container(
                      // padding: EdgeInsets.only(top: 15, bottom: 5),
                      child: Text("Management",
                          style: TextStyle(color: Colors.white, fontSize: 15))),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 15, bottom: 5),
                      child: Text("Campaigns",
                          style: TextStyle(
                            color: Colors.black54,
                          ))),
                  Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(project.fundsCampaign.length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16))),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 15, bottom: 5),
                      child: Text("Received",
                          style: TextStyle(color: Colors.black54))),
                  Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text('\$' + totalFund.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16))),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text("Target",
                          style: TextStyle(color: Colors.black54))),
                  Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('\$' + totalTarget.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16))),
                ],
              ),
            ],
          ),
        ),
      ),
      // Container(height: 200, child: Center(child: Text("fund campaigns"))),
    );
  }
}

class PFundCampaignList extends StatefulWidget {
  @override
  _PFundCampaignListState createState() => _PFundCampaignListState();
}

class _PFundCampaignListState extends State<PFundCampaignList> {
  Project project;
  bool _isLoading = true;
  List<Campaign> fundCampaigns = [];
  @override
  void initState() {
    retrieveCampaigns();
    super.initState();
  }

  retrieveCampaigns() async {
    setState(() => _isLoading = true);
    final response = await Provider.of<ManageProject>(context, listen: false)
        .retrieveCampaigns();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    project = Provider.of<ManageProject>(context).managedProject;
    fundCampaigns = Provider.of<ManageProject>(context).fundCampaigns;
    return Scaffold(
      appBar: AppBar(
        title: Text(project.projectTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontSize: 2.3 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600)),
        elevation: 5.0,
        centerTitle: false,
        leadingWidth: 30,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Fund Campaigns",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          SizedBox(height: 5),
          _isLoading
              ? Container()
              : ListView.builder(
                  itemBuilder: (_, index) {
                    return FundCampaignCard(fundCampaigns[index]);
                  },
                  itemCount: fundCampaigns.length,
                  shrinkWrap: true,
                )
        ]),
      ),
      floatingActionButton: project.projCreatorId ==
              Provider.of<Auth>(context, listen: false).myProfile.accountId
          ? FloatingActionButton(
              heroTag: "campaignCreateBtn",
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        builder: (context) => CampaignCreationScreen()))
                    .then((value) =>
                        Provider.of<ManageProject>(context, listen: false)
                            .retrieveCampaigns());
              })
          : SizedBox.shrink(),
    );
  }
}
