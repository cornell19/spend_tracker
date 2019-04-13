import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/home/widgets/custom_text.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          size: 40,
          color: Colors.yellow,
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
          Container(
            margin: EdgeInsets.only(bottom: 10),
            constraints: BoxConstraints(maxWidth: 100),
            alignment: Alignment.center,
            child: const Text('Home'),
            color: Colors.greenAccent,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 100),
            alignment: Alignment.center,
            child: const Text('Below'),
            color: Colors.greenAccent,
          ),
        ],
      )),
    );
  }
}
