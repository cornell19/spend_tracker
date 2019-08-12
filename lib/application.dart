import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/apis.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/routes.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseBloc>(
      builder: (_) => FirebaseBloc(apis: Apis()),
      dispose: (_, value) => value.dispose(),
      child: MaterialApp(
        title: 'Spend Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: routes,
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
