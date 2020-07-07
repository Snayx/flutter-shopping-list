import 'package:flutter/material.dart';
import 'dart:math';
class BuyColor {
  static const kPrimaryColorCode = 0xFF212121;
  static const kSecondaryColorCode = 0xFF212121;

  static BuyColor sharedInstance = BuyColor._();

  List<Color> storedColors;
  BuyColor._() {
    storedColors = List.generate(100, (pos) {
      return Color.fromARGB(0xff - pos * 10, Random().nextInt(255),
          Random().nextInt(255), Random().nextInt(255));
    });
  }
  Color leadingTaskColor(int pos) {
    switch (pos) {
      case 0:
        return Colors.red[900];
      case 1:
        return Colors.green[900];
      case 2:
        return Colors.blue[900];
    }

    if (pos < storedColors.length) {
      return storedColors[pos];
    }
    return Color.fromARGB(0xff - pos * 10, Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}
