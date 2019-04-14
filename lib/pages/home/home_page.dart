import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/home/widgets/custom_text.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var amount = '1,203.00';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 100,
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              '\$$amount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green,
                  Colors.white54,
                  Colors.blueGrey,
                ],
                stops: [0.85, 0.95, 1.0],
              ),
              boxShadow: [
                BoxShadow(color: Colors.grey, offset: Offset(4, 4)),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
