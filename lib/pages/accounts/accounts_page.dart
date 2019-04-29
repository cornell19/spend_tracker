import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/accounts/account_page.dart';

class AccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Accounts'),
      ),
    );
  }
}
