import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/Item_type.dart';
import 'package:spend_tracker/models/account.dart';
import 'package:spend_tracker/models/item.dart';

class ItemPage extends StatefulWidget {
  ItemPage({@required this.isDeposit});
  final bool isDeposit;
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Map<String, dynamic> _formData = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Account> _accounts = [];
  List<ItemType> _types = [];
  DateTime _dateTime = DateTime.now();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _formData['isDeposit'] = widget.isDeposit;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDropdownData();
  }

  void _loadDropdownData() async {
    var dbProvider = Provider.of<DbProvider>(context);
    var accounts = await dbProvider.getAllAccounts();
    var types = await dbProvider.getAllTypes();

    if (!mounted) return;

    setState(() {
      _accounts = accounts;
      _types = types;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (!_formKey.currentState.validate()) return;
              _formKey.currentState.save();
              var dbProvider = Provider.of<DbProvider>(context);
              _formData['date'] = DateFormat('MM/dd/yyyy').format(_dateTime);
              var item = Item.fromMap(_formData);
              dbProvider.createItem(item);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Form(
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (String value) => value.isEmpty ? 'Required' : null,
                onSaved: (String value) => _formData['description'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                },
                onSaved: (String value) =>
                    _formData['amount'] = double.parse(value),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _formData['isDeposit'],
                    onChanged: (bool value) {
                      _hasChanges = true;
                      setState(() {
                        _formData['isDeposit'] = value;
                      });
                    },
                  ),
                  const Text('Is Deposit'),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime.now().add(
                          Duration(days: -365),
                        ),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );

                      if (date == null) return;
                      _hasChanges = true;
                      setState(() {
                        _dateTime = date;
                      });
                    },
                  ),
                  Text(DateFormat('MM/dd/yyyy').format(_dateTime)),
                ],
              ),
              DropdownButtonFormField<int>(
                value: _formData['accountId'],
                decoration: InputDecoration(labelText: 'Account'),
                items: _accounts
                    .map((a) => DropdownMenuItem<int>(
                          value: a.id,
                          child: Text(a.name),
                        ))
                    .toList(),
                validator: (int value) => value == null ? 'Required' : null,
                onChanged: (int value) {
                  _hasChanges = true;
                  setState(() {
                    _formData['accountId'] = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Type'),
                value: _formData['typeId'],
                items: _types
                    .map((t) =>
                        DropdownMenuItem<int>(value: t.id, child: Text(t.name)))
                    .toList(),
                onChanged: (int value) {
                  _hasChanges = true;
                  setState(() {
                    _formData['typeId'] = value;
                  });
                },
                validator: (int value) => value == null ? 'Required' : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
