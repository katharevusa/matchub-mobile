import 'package:json_annotation/json_annotation.dart';

import 'campaign.dart';
import 'donation.dart';

part 'campaignOption.g.dart';

@JsonSerializable()
class CampaignOption {
  CampaignOption();

  num donationOptionId;
  num amount;
  String optionDescription;
  Campaign fundCampaign;
  List<Donation> donations;

  factory CampaignOption.fromJson(Map<String, dynamic> json) => _$CampaignOptionFromJson(json);
}
