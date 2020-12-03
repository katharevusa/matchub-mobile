// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resourceTransaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceTransaction _$ResourceTransactionFromJson(Map<String, dynamic> json) {
  return ResourceTransaction()
    ..resourceTransactionId = json['resourceTransactionId'] as num
    ..transactionTime = DateTime.parse(json['transactionTime'])
    ..amountPaid = json['amountPaid'] as double
    ..payerId = json['payerId'] as num
    ..resource =
        json['resource'] != null ? Resources.fromJson(json['resource']) : null
    ..project =
        json['project'] != null ? Project.fromJson(json['project']) : null;
}

Map<String, dynamic> _$ResourceTransactionToJson(
        ResourceTransaction instance) =>
    <String, dynamic>{
      'resourceTransactionId': instance.resourceTransactionId,
      'transactionTime': instance.transactionTime,
      'amountPaid': instance.amountPaid,
      'payerId': instance.payerId,
      'resource': instance.resource,
      'project': instance.project,
    };
