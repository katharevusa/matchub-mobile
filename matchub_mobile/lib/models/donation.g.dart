// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Donation _$DonationFromJson(Map<String, dynamic> json) {
  return Donation()
    ..donationId = json['donationId'] as num
    ..donatedAmount = json['donatedAmount'] as num
    ..donator = TruncatedProfile.fromJson(json['donator'])
        ..donationTime = DateTime.parse(json['donationTime'])
    ..donationOption = json['donationOption'] != null ? CampaignOption.fromJson(json['donationOption']) : null;
}