import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/campaign/campaignDonors.dart';
import 'package:matchub_mobile/screens/campaign/campaignEdit.dart';
import 'package:matchub_mobile/screens/campaign/paymentScreen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/pCarousel.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageProject.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../style.dart';

class ViewCampaign extends StatefulWidget {
  Project project;
  Campaign campaign;
  bool isPublic;

  ViewCampaign({this.project, this.campaign, this.isPublic = true});

  @override
  _ViewCampaignState createState() => _ViewCampaignState();
}

class _ViewCampaignState extends State<ViewCampaign> {
  List<Donation> allBackers = [];
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
    (responseData as List).forEach((e) => allBackers.indexWhere((element) =>
                element.donator.accountId ==
                Donation.fromJson(e).donator.accountId) ==
            -1
        ? allBackers.add(Donation.fromJson(e))
        : null);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPublic)
      widget.campaign = Provider.of<ManageProject>(context).managedCampaign;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            children: [
              PCarousel(widget.project),
              if (widget.project.projCreatorId ==
                  Provider.of<Auth>(context, listen: false).myProfile.accountId)
                Positioned(
                  right: 10,
                  child: SafeArea(
                    child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.more_vert_rounded,
                          size: 24,
                          color: Colors.white,
                        ),
                        itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CampaignEdit(
                                        campaign: widget.campaign,
                                        project: widget.project,
                                      ),
                                    ),
                                  ).then((value) => Navigator.pop(context)),
                                  dense: true,
                                  leading: Icon(
                                    Icons.edit,
                                  ),
                                  title: Text(
                                    "Edit Campaign",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.8),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ViewCampaignDonors(
                                        campaign: widget.campaign,
                                      ),
                                    ),
                                  ).then((value) => Navigator.pop(context)),
                                  dense: true,
                                  leading: Icon(
                                    Icons.people_alt_rounded,
                                  ),
                                  title: Text(
                                    "View Campaign Donors",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.8),
                                  ),
                                ),
                              ),
                            ]),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              widget.campaign.campaignTitle,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 3 * SizeConfig.textMultiplier),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 0.5 * SizeConfig.heightMultiplier, horizontal: 30),
            child: ReadMoreText(
              widget.campaign.campaignDescription,
              trimLines: 3,
              style: TextStyle(
                height: 1.5,
                wordSpacing: -1.9,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.justify,
              colorClickableText: kSecondaryColor,
              trimMode: TrimMode.Line,
              trimCollapsedText: '    show more',
              trimExpandedText: '\nshow less',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: FAProgressBar(
              progressColor: kKanbanColor,
              backgroundColor: Colors.grey[200],
              size: 6,
              animatedDuration: const Duration(milliseconds: 800),
              maxValue: widget.campaign.campaignTarget.toInt(),
              currentValue: widget.campaign.currentAmountRaised.toInt(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                                "S\$ " +
                                    widget.campaign.currentAmountRaised
                                        .toStringAsFixed(0),
                                style: TextStyle(
                                  color: kKanbanColor,
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                  fontFamily: "Lato",
                                )),
                          ),
                        ),
                        Text("pledged of S\$ " +
                            widget.campaign.campaignTarget.toStringAsFixed(0))
                      ]),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on_rounded,
                          color: Colors.grey[800], size: 28),
                      SizedBox(width: 5),
                      Text((widget.campaign.currentAmountRaised *
                                  100 ~/
                                  widget.campaign.campaignTarget)
                              .toString() +
                          "%"),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(Icons.timelapse_rounded,
                          color: Colors.grey[800], size: 28),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(widget.campaign.endDate
                                .difference(DateTime.now())
                                .inDays
                                .toString() +
                            " days to go"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "In support of\n",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 1.7 * SizeConfig.textMultiplier,
                              // fontFamily: "Lato",
                            )),
                        TextSpan(
                          text: widget.project.projectTitle,
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontWeight: FontWeight.w500,
                              fontSize: 1.8 * SizeConfig.textMultiplier),
                        ),
                      ])),
                ),
                SizedBox(width: 5),
                OutlineButton(
                  color: Colors.grey[500],
                  child: Text("View"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            ProjectDetailScreen(project: widget.project)));
                  },
                )
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Support",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 2 * SizeConfig.textMultiplier),
                ),
                Text(
                  "${allBackers.length} backers",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (_, idx) {
                return DonationOptionCard(
                    donationOption: widget.campaign.donationOptions[idx],
                    project: widget.project);
              },
              itemCount: widget.campaign.donationOptions.length),
        ]),
      ),
    );
  }
}

class DonationOptionCard extends StatelessWidget {
  DonationOptionCard(
      {Key key,
      @required this.donationOption,
      @required this.project,
      this.backgroundColor,
      this.isPublic = true})
      : super(key: key);
  final bool isPublic;
  final Project project;
  final CampaignOption donationOption;
  final TextEditingController pledgeController = TextEditingController();
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    pledgeController.text = donationOption.amount.toStringAsFixed(0);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pledge S\$ ${donationOption.amount.toStringAsFixed(0)} or more",
                style: TextStyle(
                    color: Colors.grey[850],
                    fontWeight: FontWeight.w400,
                    fontSize: 2 * SizeConfig.textMultiplier),
              ),
              if (!isPublic &&
                  !donationOption.optionDescription.contains("Default"))
                IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await ApiBaseHelper.instance.deleteProtected(
                          "authenticated/deleteDonationOption?donationOptionId=${donationOption.donationOptionId}");
                      await Provider.of<ManageProject>(context, listen: false)
                          .retrieveCampaign();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey[400],
                    ))
            ],
          ),
          SizedBox(height: 10),
          Text(
            donationOption.optionDescription,
            style: TextStyle(
                color: Colors.grey[850],
                fontSize: 1.7 * SizeConfig.textMultiplier),
          ),
          SizedBox(height: 10),
          Text(
            "133 backers",
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w400,
              fontSize: 1.5 * SizeConfig.textMultiplier,
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            autovalidate: true,
            controller: pledgeController,
            decoration: InputDecoration(
              labelText: 'Pledge Amount (\$)',
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
            readOnly: !isPublic,
            onEditingComplete: () =>
                FocusManager.instance.primaryFocus.unfocus(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              // CustomRangeTextInputFormatter(
              //     minValue: donationOption.amount.toInt())
            ],
            onChanged: (value) {
              // newCampaign['campaignTarget'] = value;
              pledgeController.selection = TextSelection.fromPosition(
                  TextPosition(offset: pledgeController.text.length));
            },
            validator: (val) {
              if (val.isEmpty || int.parse(val) < donationOption.amount) {
                return "Please input a valid amount";
              }
            },
          ),
          if (isPublic) ...[
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: RaisedButton(
                  highlightElevation: 8,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Select",
                    style: TextStyle(fontSize: 16),
                  ),
                  color: AppTheme.projectPink,
                  textColor: Colors.white,
                  onPressed: () {
                    if (int.parse(pledgeController.text) >=
                        donationOption.amount) {
                      Navigator.of(context, rootNavigator: true)
                          .push(
                        PageRouteBuilder(
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return PaymentScreen(
                                donationOption: donationOption,
                                selectedAmount: pledgeController.text,
                                project: project);
                          },
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            final Widget transition = SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0.0, 1.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset.zero,
                                  end: Offset(0.0, -0.7),
                                ).animate(secondaryAnimation),
                                child: child,
                              ),
                            );
                            return transition;
                          },
                          transitionDuration: Duration(milliseconds: 300),
                        ),
                      )
                          .then((value) {
                        Provider.of<ManageProject>(context, listen: false)
                            .retrieveCampaign();
                        Provider.of<ManageProject>(context, listen: false)
                            .retrieveCampaigns();
                      });
                    }
                  }),
            )
          ],
        ],
      ),
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  final int minValue;

  CustomRangeTextInputFormatter({@required this.minValue});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < 0)
      return TextEditingValue().copyWith(text: '0');

    return int.parse(newValue.text) < minValue
        ? TextEditingValue().copyWith(text: minValue.toString())
        : newValue;
  }
}
