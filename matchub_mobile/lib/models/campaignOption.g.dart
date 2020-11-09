// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaignOption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignOption _$CampaignOptionFromJson(Map<String, dynamic> json) {
  return CampaignOption()
    ..donationOptionId = json['donationOptionId'] as num
    ..amount = json['amount'] as num
    ..optionDescription = json['optionDescription'] as String
    ..fundCampaign = Campaign.fromJson(json['fundCampaign'])
    ..donations =  json['donations'] != null
        ? (json['donations'] as List)
            .map((i) => Donation.fromJson(i))
            .toList()
        : [];
}