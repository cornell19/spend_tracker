import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Map<String, dynamic> _formData = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isDeposit = true;
  DateTime _dateTime = DateTime.now();

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
                Navigator.of(context).pop();
              }),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (String value) => value.isEmpty ? 'Required' : null,
                onSaved: (String value) => _formData['description'] = value,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                },
                onSaved: (String value) =>
                    _formData['amount'] = double.parse(value),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isDeposit,
                    onChanged: (bool value) {
                      setState(() {
                        _isDeposit = value;
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
                        firstDate: DateTime.now().add(Duration(days: -365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date == null) return;

                      setState(() {
                        _dateTime = date;
                      });
                    },
                  ),
                  Text(DateFormat('MM/dd/yyyy').format(_dateTime)),
                ],
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Account'),
                value: _formData['accountId'],
                onChanged: (int value) {
                  _formData['accountId'] = value;
                  setState(() {
                    _formData['accountId'] = value;
                  });
                },
                validator: (int value) => value == null ? 'Required' : null,
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('Checking'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text('Credit Card'),
                  ),
                ],
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Type'),
                value: _formData['typeId'],
                onChanged: (int value) {
                  _formData['typeId'] = value;
                  setState(() {
                    _formData['typeId'] = value;
                  });
                },
                validator: (int value) => value == null ? 'Required' : null,
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('Rent'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text('Dinner'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
