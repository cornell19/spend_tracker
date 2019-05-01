import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';

class TypePage extends StatefulWidget {
  @override
  _TypePageState createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  Map<String, dynamic> _data = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconData _newIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Type'),
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
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              IconHolder(
                newIcon: _newIcon,
                onIconChange: (iconData) {
                  setState(() {
                    _newIcon = iconData;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                },
                onSaved: (String value) => _data['name'] = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
