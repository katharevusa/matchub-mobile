import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'donation.g.dart';

@JsonSerializable()
class Donation {
  Donation();

  num donationId;
  num donatedAmount;
  TruncatedProfile donator;
  DateTime donationTime;
  CampaignOption donationOption;

  factory Donation.fromJson(Map<String, dynamic> json) => _$DonationFromJson(json);
}
