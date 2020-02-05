import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/balance.dart';
import 'package:spend_tracker/pages/home/widgets/menu.dart';
import 'package:spend_tracker/pages/items/item_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Balance _balance;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var dbProvider = Provider.of<DbProvider>(context);
    var balance = await dbProvider.getBalance();
    setState(() {
      _balance = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat("#,##0.00", "en_US");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'add',
            onPressed: () => print('click'),
          )
        ],
      ),
      drawer: Menu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _TotalBudget(
              amount: formatter.format(_balance == null ? 0 : _balance.total)),
          Expanded(
            flex: 1,
            child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
              var maxHeight = constraints.biggest.height;
              maxHeight = maxHeight - 50;
              double dHeight = 0;
              double wHeight = 0;
              if (_balance == null ||
                  (_balance.deposit == 0 && _balance.withdraw == 0)) {
                return Container(height: maxHeight);
              }
              if (_balance.withdraw > _balance.deposit) {
                wHeight = maxHeight;
                dHeight = (maxHeight * _balance.deposit) / _balance.withdraw;
              } else {
                dHeight = maxHeight;
                wHeight = (maxHeight * _balance.withdraw) / _balance.deposit;
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _BarLine(wHeight, Colors.red, 'Withdraw',
                      formatter.format(_balance.withdraw)),
                  _BarLine(dHeight, Colors.green, 'Deposit',
                      formatter.format(_balance.deposit))
                ],
              );
            }),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
      floatingActionButton: PopupMenuButton(
        child: Icon(
          Icons.add_circle,
          size: 60,
          color: Theme.of(context).primaryColor,
        ),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 1,
            child: const Text('Deposit'),
          ),
          PopupMenuItem(
            value: 2,
            child: const Text('Withdraw'),
          )
        ],
        onSelected: (int value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItemPage(
                isDeposit: value == 1,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _BarLine extends StatelessWidget {
  const _BarLine(
    this.height,
    this.color,
    this.label,
    this.amount, {
    Key key,
  }) : super(key: key);
  final double height;
  final String label;
  final Color color;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: height,
          width: 100,
          color: color,
        ),
        Text(label),
        Text(amount),
      ],
    );
  }
}

class _TotalBudget extends StatelessWidget {
  const _TotalBudget({
    Key key,
    @required this.amount,
  }) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
