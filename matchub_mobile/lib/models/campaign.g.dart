// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Campaign _$CampaignFromJson(Map<String, dynamic> json) {
  return Campaign()
    ..fundsCampaignId = json['fundsCampaignId'] as num
    ..campaignTitle = json['campaignTitle'] as String
    ..campaignDescription = json['campaignDescription'] as String
    ..endDate = DateTime.parse(json['endDate'])
    ..campaignTarget = json['campaignTarget'] as num
    ..currentAmountRaised = json['currentAmountRaised'] as num
    ..projectId = json['projectId'] as num
    ..payeeId = json['payeeId'] as num
    ..activated = json['activated'] as bool
    ..stripeAccountUid = json['stripeAccountUid'] as String
    ..donationOptions =  json['donationOptions'] != null
        ? (json['donationOptions'] as List)
            .map((i) => CampaignOption.fromJson(i))
            .toList()
        : [];
}