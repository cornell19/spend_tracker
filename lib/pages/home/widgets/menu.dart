import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Accounts'),
            onTap: () => Navigator.of(context).pushNamed('/accounts'),
          ),
          ListTile(
            title: const Text('Budget Items'),
            onTap: () => Navigator.of(context).pushNamed('/items'),
          ),
          ListTile(
            title: const Text('Types'),
            onTap: () => Navigator.of(context).pushNamed('/types'),
          ),
        ],
      ),
    );
  }
}
