import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spend_tracker/application.dart';

void main() async {
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(Application());
}
