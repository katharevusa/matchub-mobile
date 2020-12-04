import 'package:flutter/foundation.dart';

class DonationInfo {
  final String title;
  final double amount;
  final DateTime date;

  DonationInfo({
    @required this.title,
    @required this.amount,
    @required this.date,
  });
}
