import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/Item_type.dart';
import 'package:spend_tracker/support/icon_helper.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';

class TypePage extends StatefulWidget {
  TypePage({this.type});
  final ItemType type;
  @override
  _TypePageState createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  Map<String, dynamic> _data;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;
  @override
  void initState() {
    super.initState();
    if (widget.type != null) {
      _data = widget.type.toMap();
    } else {
      _data = Map<String, dynamic>();
      _data['codePoint'] = Icons.add.codePoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DbProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Type'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                if (!_formKey.currentState.validate()) return;
                _formKey.currentState.save();
                var type = ItemType.fromMap(_data);
                if (type.id == null)
                  await dbProvider.createType(type);
                else
                  await dbProvider.updateType(type);
                Navigator.of(context).pop();
              }),
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
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              IconHolder(
                newIcon: IconHelper.createIconData(_data['codePoint']),
                onIconChange: (iconData) {
                  _hasChanges = true;
                  setState(() {
                    _data['codePoint'] = iconData.codePoint;
                  });
                },
              ),
              TextFormField(
                initialValue: widget.type != null ? widget.type.name : '',
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
