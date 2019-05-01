import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/types/type_page.dart';

class TypesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => TypePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Types'),
      ),
    );
  }
}
