import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:matchub_mobile/widgets/popupmenubutton.dart' as popupmenu;
import 'package:flutter/services.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/campaign/view_campaign.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';

class CampaignEdit extends StatefulWidget {
  Campaign campaign;
  Project project;
  CampaignEdit({this.campaign, this.project});
  @override
  _CampaignEditState createState() => _CampaignEditState();
}

class _CampaignEditState extends State<CampaignEdit>
    with TickerProviderStateMixin {
  TabController _controller;
  Map<String, dynamic> editedCampaign;
  @override
  void initState() {
    editedCampaign = {
      "campaignId": widget.campaign.fundsCampaignId,
      "campaignTitle": widget.campaign.campaignTitle,
      "campaignDescription": widget.campaign.campaignDescription,
      "endDate": widget.campaign.endDate.toIso8601String(),
      "targetAmount": widget.campaign.campaignTarget,
    };
    _controller = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    widget.campaign = Provider.of<ManageProject>(context).managedCampaign;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Campaign",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        ),
        actions: [
          popupmenu.PopupMenuButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_vert_rounded,
                size: 24,
                color: Colors.white,
              ),
              itemBuilder: (BuildContext context) => [
                    popupmenu.PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              // title: Text('Are you sure?'),
                              content: Text(
                                  "Are you sure you wish to delete this campaign?"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('No'),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    try {
                                      await ApiBaseHelper.instance.deleteProtected(
                                          "authenticated/deleteFundCampaign?fundCampaignId=${widget.campaign.fundsCampaignId}");
                                      var service = Provider.of<ManageProject>(
                                          context,
                                          listen: false);
                                      service.getProject(widget.project.projectId);
                                      service.retrieveCampaigns();
                                      Navigator.of(context)
                                          .popUntil(ModalRoute.withName("/"));
                                    } catch (e) {
                                      showErrorDialog(
                                          "Campaign has already received donations. Unable to delete.",
                                          context);
                                    }
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          );
                          showDialog();
                          Navigator.of(context).pop(true);
                        },
                        dense: true,
                        leading: Icon(
                          FlutterIcons.trash_alt_faw5s,
                        ),
                        title: Text(
                          "Delete Campaign",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                      ),
                    )
                  ]),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(
              child: Text("Basic Information"),
            ),
            Tab(
              child: Text("Donation Options"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fundraising Campaign Title',
                  hintText: 'Fill in your campaign title here.',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 12),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                maxLength: 50,
                maxLengthEnforced: true,
                initialValue: widget.campaign.campaignTitle,
                onChanged: (value) {
                  editedCampaign['campaignTitle'] = value;
                },
                validator: (newName) {
                  if (newName.isEmpty) {
                    return "Please enter a campaign name";
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Provide more details about your fundraiser here.',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 12),
                  fillColor: Colors.grey[100],
                  hoverColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 6,
                maxLines: 10,
                initialValue: widget.campaign.campaignDescription,
                onChanged: (value) {
                  editedCampaign['campaignDescription'] = value;
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please input a campaign description";
                  }
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: AppTheme.projectPink,
                onPressed: () async {
                  await Provider.of<ManageProject>(context, listen: false)
                      .updateCampaign(editedCampaign);
                  Navigator.pop(context);
                },
                child: Text("Submit",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ]),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                RaisedButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: AppTheme.projectPink,
                    child: Text(
                      "Create Donation Option",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0)),
                        ),
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) {
                          return DonationOptionCreatePopup(
                              campaignId: widget.campaign.fundsCampaignId);
                        },
                      ).then((value) => setState(() {}));
                    }),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (_, idx) {
                      return DonationOptionCard(
                        donationOption: widget.campaign.donationOptions[idx],
                        project: widget.project,
                        isPublic: false,
                      );
                    },
                    itemCount: widget.campaign.donationOptions.length),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DonationOptionCreatePopup extends StatefulWidget {
  DonationOptionCreatePopup({
    Key key,
    @required this.campaignId,
  }) : super(key: key);

  num campaignId;

  @override
  _DonationOptionCreatePopupState createState() =>
      _DonationOptionCreatePopupState();
}

class _DonationOptionCreatePopupState extends State<DonationOptionCreatePopup> {
  Map<String, dynamic> newDonationOption;
  initState() {
    newDonationOption = {
      "fundCampaignId": widget.campaignId,
      "optionDescription": null,
      "amount": null
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 10,
          right: 20,
          left: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("New Donation Option",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                FlatButton(
                  color: kKanbanColor,
                  onPressed: () async {
                    await ApiBaseHelper.instance.postProtected(
                        "authenticated/createDonationOption",
                        body: json.encode(newDonationOption));
                    await Provider.of<ManageProject>(context, listen: false)
                        .retrieveCampaign();
                    await Provider.of<ManageProject>(context, listen: false)
                        .retrieveCampaigns();
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Create",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 2 * SizeConfig.textMultiplier),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Provide more details about your option here.',
                labelStyle: TextStyle(color: Colors.grey[850], fontSize: 12),
                fillColor: Colors.grey[100],
                hoverColor: Colors.grey[100],
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kSecondaryColor),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: kSecondaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 5,
              onChanged: (value) {
                newDonationOption['optionDescription'] = value;
              },
              validator: (val) {
                if (val.isEmpty) {
                  return "Please input a description";
                }
              },
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fundraising Target (\$)',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 12),
                  fillColor: Colors.grey[100],
                  hoverColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  newDonationOption['amount'] = value;
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please input a valid amount";
                  }
                },
              ),
            ),
            SizedBox(height: 20),
          ]),
    ));
  }
}
