import 'package:flutter/material.dart';

class IconHelper {
  static IconData createIconData(int codePoint) {
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }
}
