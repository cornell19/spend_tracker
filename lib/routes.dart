import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/index.dart';

final routes = {
  '/': (_) => LoginPage(),
  '/home': (_) => HomePage(),
  '/accounts': (_) => AccountsPage(),
  '/items': (_) => ItemsPage(),
  '/types': (_) => TypesPage(),
};

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
