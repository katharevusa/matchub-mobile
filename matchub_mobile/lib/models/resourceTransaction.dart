import 'package:json_annotation/json_annotation.dart';
import 'package:matchub_mobile/models/index.dart';

part 'resourceTransaction.g.dart';

@JsonSerializable()
class ResourceTransaction {
  ResourceTransaction();

  num resourceTransactionId;
  DateTime transactionTime;
  double amountPaid;
  num payerId;
  Resources resource;
  Project project;

  factory ResourceTransaction.fromJson(Map<String, dynamic> json) =>
      _$ResourceTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$ResourceTransactionToJson(this);
}
