import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/models/balance.dart';
import 'package:spend_tracker/pages/home/widgets/menu.dart';
import 'package:spend_tracker/pages/items/item_page.dart';
import 'package:spend_tracker/routes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with RouteAware, WidgetsBindingObserver, TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  Balance _balance;
  double _opacity = 0.2;
  double _fontSize = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _setHeightBalances();
    routeObserver.subscribe(this, ModalRoute.of(context));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void didPopNext() {
    _setHeightBalances();
    _controller.forward();
  }

  @override
  void didPushNext() {
    _controller.reset();
  }

  void _setHeightBalances() {
    var bloc = Provider.of<FirebaseBloc>(context);
    Balance balance = bloc.balance;

    setState(() {
      _balance = balance;
      _opacity = 1.0;
      _fontSize = 40;
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
          AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(seconds: 4),
            child: _TotalBudget(
              fontSize: _fontSize,
              amount: formatter.format(_balance == null ? 0 : _balance.total),
            ),
          ),
          Expanded(
            flex: 1,
            child: LayoutBuilder(builder: (context, constraints) {
              var maxHeight = constraints.biggest.height;
              maxHeight = maxHeight - 50;
              double dHeight = 0;
              double wHeight = 0;

              if (_balance == null ||
                  (_balance.deposit == 0 && _balance.withdraw == 0)) {
                return Container();
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
                      formatter.format(_balance.withdraw), _animation),
                  _BarLine(dHeight, Colors.green, 'Deposit',
                      formatter.format(_balance.deposit), _animation),
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
    this.amount,
    this.animation, {
    Key key,
  }) : super(key: key);
  final double height;
  final String label;
  final Color color;
  final String amount;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
            animation: animation,
            builder: (_, __) {
              return Container(
                height: animation.value * height,
                width: 100,
                color: color,
              );
            }),
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
    @required this.fontSize,
  }) : super(key: key);

  final String amount;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: AnimatedDefaultTextStyle(
        duration: Duration(seconds: 3),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
        child: Text(
          '\$$amount',
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
