import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/index.dart';

final routes = {
  '/': (BuildContext context) => HomePage(),
  '/accounts': (BuildContext context) => AccountsPage(),
  '/items': (BuildContext context) => ItemsPage(),
  '/types': (BuildContext context) => TypesPage(),
};
