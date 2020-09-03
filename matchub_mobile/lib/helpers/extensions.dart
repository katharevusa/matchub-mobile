import 'package:flutter/material.dart';

extension CapExtension on String {
  String get capitalize =>
      '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  String get capitalizeWords {
    List<String> list = this.split(" ");
    var temp = list.map((word) => word.capitalize).toList();
    print(temp);
    return temp.join(" ");
  }

  String get allInCaps => this.toUpperCase();
}

extension TimeOfDayComparison on TimeOfDay {
  bool isAfter(TimeOfDay time2) {
    if (this.hour > time2.hour) return true;
    if (this.hour < time2.hour) return false;
    if (this.minute > time2.minute) return true;
    return false;
  }
}
