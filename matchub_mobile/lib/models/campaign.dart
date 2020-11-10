import 'package:json_annotation/json_annotation.dart';

import 'campaignOption.dart';

part 'campaign.g.dart';

@JsonSerializable()
class Campaign {
  Campaign();

  num fundsCampaignId;
  String campaignTitle;
  String campaignDescription;
  num campaignTarget;
  num currentAmountRaised;
  DateTime endDate;
  String stripeAccountUid;
  bool activated;
  num projectId;
  num payeeId;
  List<CampaignOption> donationOptions;

  factory Campaign.fromJson(Map<String, dynamic> json) => _$CampaignFromJson(json);
}
