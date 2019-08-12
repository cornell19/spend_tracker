import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/models/item.dart';

class ItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<FirebaseBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Items'),
        ),
        body: StreamBuilder<List<Item>>(
          stream: bloc.items,
          builder: (_, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text(snapshot.error.toString()),
              );
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );

            var items = snapshot.data;

            if (items.length == 0)
              return Center(
                child: const Text('No Records'),
              );

            var formatter = NumberFormat("#,##0.00", "en_US");

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, int index) {
                var item = items[index];
                return Dismissible(
                  key: ObjectKey(item.urlId),
                  confirmDismiss: (DismissDirection direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await bloc.deleteItem(item);
                      return true;
                    }
                    return false;
                  },
                  background: Container(
                    padding: EdgeInsets.only(right: 3),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Text('Delete',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: item.isDeposit ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                    title: Text(item.description),
                    trailing: Text('\$${formatter.format(item.amount)}'),
                  ),
                );
              },
            );
          },
        ));
  }
}
