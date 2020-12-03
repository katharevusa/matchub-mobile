import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/campaign/campaignCreation.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/widgets/campaignCard.dart';
import 'package:provider/provider.dart';

class PFundCampaignCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PFundCampaignList()));
      },
      child:
          Container(height: 200, child: Center(child: Text("fund campaigns"))),
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
