import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/models/models.dart';
import 'package:spend_tracker/routes.dart';

class ItemPage extends StatefulWidget {
  ItemPage({@required this.isDeposit});
  final bool isDeposit;
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> with RouteAware {
  Map<String, dynamic> _formData = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();
  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _formData['isDeposit'] = widget.isDeposit;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  void didPop() {
    print('did pop');
  }

  void didPush() {
    print('did push');
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<FirebaseBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (!_formKey.currentState.validate()) return;
              _formKey.currentState.save();
              setState(() {
                _isSaving = true;
              });
              _formData['date'] = DateFormat('MM/dd/yyyy').format(_dateTime);
              var item = Item.fromMap(_formData);
              await bloc.createItem(item);
              Navigator.of(context).pop();
            },
          )
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (String value) =>
                          value.isEmpty ? 'Required' : null,
                      onSaved: (String value) =>
                          _formData['description'] = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Amount'),
                      validator: (String value) {
                        if (value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null)
                          return 'Invalid number';
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
                    _AccountsDropdown(
                      bloc: bloc,
                      urlId: _formData['accountUrlId'],
                      onChanged: (String value) {
                        _hasChanges = true;
                        setState(() {
                          _formData['accountUrlId'] = value;
                        });
                      },
                    ),
                    _TypesDropdown(
                      bloc: bloc,
                      urlId: _formData['typeUrlId'],
                      onChanged: (String value) {
                        _hasChanges = true;
                        setState(() {
                          _formData['typeUrlId'] = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class _TypesDropdown extends StatelessWidget {
  const _TypesDropdown({
    Key key,
    @required this.bloc,
    @required this.urlId,
    @required this.onChanged,
  }) : super(key: key);

  final FirebaseBloc bloc;
  final String urlId;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemType>>(
        stream: bloc.itemTypes,
        builder: (_, AsyncSnapshot<List<ItemType>> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );
          if (!snapshot.hasData)
            return Center(
              child: const Text('No Records'),
            );
          var types = snapshot.data;

          return DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Type'),
            value: urlId,
            items: types
                .map((t) => DropdownMenuItem<String>(
                    value: t.urlId, child: Text(t.name)))
                .toList(),
            onChanged: onChanged,
            validator: (String value) => value == null ? 'Required' : null,
          );
        });
  }
}

class _AccountsDropdown extends StatelessWidget {
  const _AccountsDropdown({
    Key key,
    @required this.bloc,
    @required this.urlId,
    @required this.onChanged,
  }) : super(key: key);

  final FirebaseBloc bloc;
  final String urlId;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Account>>(
        stream: bloc.accounts,
        builder: (_, AsyncSnapshot<List<Account>> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );
          if (!snapshot.hasData)
            return Center(
              child: const Text('No Records'),
            );
          var accounts = snapshot.data;

          return DropdownButtonFormField<String>(
              value: urlId,
              decoration: InputDecoration(labelText: 'Account'),
              items: accounts
                  .map((a) => DropdownMenuItem<String>(
                        value: a.urlId,
                        child: Text(a.name),
                      ))
                  .toList(),
              validator: (String value) => value == null ? 'Required' : null,
              onChanged: onChanged);
        });
  }
}
