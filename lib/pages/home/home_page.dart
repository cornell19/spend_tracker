import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
        ),
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'add',
            onPressed: () => print('click'),
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('one'),
          const Text('two'),
          const Text('three'),
        ],
      )),
    );
  }
}
