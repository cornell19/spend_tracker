import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    var bloc = Provider.of<FirebaseBloc>(context);
    return SizedBox(
      width: 150,
      child: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              alignment: Alignment.bottomCenter,
              child: Text(
                'MENU',
                style: TextStyle(
                  fontSize: 20,
                  color: color,
                ),
              ),
            ),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
                title: 'Accounts',
                color: color,
                icon: Icons.account_balance,
                onTap: () {
                  bloc.getAccounts();
                  onNavigate(context, '/accounts');
                }),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
                title: 'Budget Items',
                color: color,
                icon: Icons.attach_money,
                onTap: () => onNavigate(context, '/items')),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
                title: 'Types',
                color: color,
                icon: Icons.widgets,
                onTap: () => onNavigate(context, '/types')),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
                title: 'Logout',
                color: color,
                icon: Icons.security,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                }),
          ],
        ),
      ),
    );
  }

  void onNavigate(BuildContext context, String uri) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(uri);
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    Key key,
    @required this.color,
    @required this.title,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: 0.6,
        child: Container(
          height: 70,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Icon(icon, color: color, size: 50.0),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
