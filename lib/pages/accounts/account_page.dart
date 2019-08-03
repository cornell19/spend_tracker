import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/models/account.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';
import 'package:spend_tracker/support/icon_helper.dart';

class AccountPage extends StatefulWidget {
  AccountPage({this.account});
  final Account account;
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with TickerProviderStateMixin {
  Map<String, dynamic> _data;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;
  AnimationController _controller;
  Animation<Offset> _animationName;
  Animation<Offset> _animationBalance;
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _data = widget.account.toMap();
    } else {
      _data = Map<String, dynamic>();
      _data['codePoint'] = Icons.add.codePoint;
    }
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationName = Tween<Offset>(begin: Offset(-3, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.50, 1.0, curve: Curves.easeInOutBack)));
    _animationBalance = Tween<Offset>(begin: Offset(-3, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.5, curve: Curves.easeInOutBack)));
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<FirebaseBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;
                  setState(() {
                    _isSaving = true;
                  });
                  _formKey.currentState.save();
                  var account = Account.fromMap(_data);
                  if (account.urlId == null)
                    await bloc.createAccount(account);
                  else
                    await bloc.updateAccount(account);

                  Navigator.of(context).pop();
                }),
          ],
        ),
        body: _isSaving
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                onWillPop: () {
                  if (_hasChanges) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm'),
                            content: const Text('Discard Changes?'),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: const Text('No'),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          );
                        });
                    return Future.value(false);
                  }

                  return Future.value(true);
                },
                onChanged: () => _hasChanges = true,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      IconHolder(
                        tagUrlId:
                            widget.account == null ? '0' : widget.account.urlId,
                        newIcon: IconHelper.createIconData(_data['codePoint']),
                        onIconChange: (iconData) {
                          if (iconData == null) return;
                          _hasChanges = true;
                          setState(() {
                            _data['codePoint'] = iconData.codePoint;
                          });
                        },
                      ),
                      SlideTransition(
                        position: _animationName,
                        child: TextFormField(
                          initialValue:
                              widget.account != null ? widget.account.name : '',
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (String value) {
                            if (value.isEmpty) return 'Required';
                          },
                          onSaved: (String value) => _data['name'] = value,
                        ),
                      ),
                      SlideTransition(
                        position: _animationBalance,
                        child: TextFormField(
                          initialValue: widget.account != null
                              ? widget.account.balance.toString()
                              : '',
                          decoration: InputDecoration(labelText: 'Balance'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (String value) {
                            if (value.isEmpty) return 'Required';
                            if (double.tryParse(value) == null)
                              return 'Invalid number';
                          },
                          onSaved: (String value) =>
                              _data['balance'] = double.parse(value),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
