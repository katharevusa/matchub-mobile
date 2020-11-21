import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/campaign/view_campaign.dart';
import 'package:matchub_mobile/screens/search/project_search_card.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'attachment_image.dart';

class FundCampaignCard extends StatefulWidget {
  Campaign campaign;
  FundCampaignCard(this.campaign);
  @override
  _FundCampaignCardState createState() => _FundCampaignCardState();
}

class _FundCampaignCardState extends State<FundCampaignCard> {
  Project project;
  bool _isLoading = true;
  @override
  void initState() {
    getProject();
    super.initState();
  }

  getProject() async {
    print(widget.campaign);
    final response = await ApiBaseHelper.instance.getProtected(
        "authenticated/getProject?projectId=${widget.campaign.projectId}");
    project = Project.fromJson(response);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey[300],
            child: ProjectLoader(),
            period: Duration(milliseconds: 800),
          )
        : GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) {
                    Provider.of<ManageProject>(context, listen: false)
                        .managedCampaign = widget.campaign;
                    return ViewCampaign(project: project, campaign: widget.campaign, isPublic: false);
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 0 * SizeConfig.widthMultiplier),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ]),
                          width: 24 * SizeConfig.widthMultiplier,
                          height: 30 * SizeConfig.widthMultiplier,
                          child: AttachmentImage(project.photos[
                              Random().nextInt(project.photos.length)]))),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.widthMultiplier,
                          vertical: 1 * SizeConfig.heightMultiplier),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.campaign.campaignTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 1.8 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: FAProgressBar(
                              progressColor: kKanbanColor,
                              backgroundColor: Colors.grey[200],
                              size: 6,
                              animatedDuration:
                                  const Duration(milliseconds: 2500),
                              maxValue: widget.campaign.campaignTarget.toInt(),
                              currentValue:
                                  widget.campaign.currentAmountRaised.toInt(),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.monetization_on_rounded,
                                  color: Colors.grey[800], size: 28),
                              SizedBox(width: 5),
                              Text((widget.campaign.currentAmountRaised *
                                          100 ~/
                                          widget.campaign.campaignTarget)
                                      .toString() +
                                  "%"),
                              SizedBox(width: 10),
                              Icon(Icons.timelapse_rounded,
                                  color: Colors.grey[800], size: 28),
                              SizedBox(width: 5),
                              Text(widget.campaign.endDate
                                      .difference(DateTime.now())
                                      .inDays
                                      .toString() +
                                  " days to go"),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
