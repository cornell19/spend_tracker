import 'dart:convert';

import 'package:meta/meta.dart';

class Item {
  Item(
      {this.id,
      this.urlId,
      @required this.description,
      @required this.amount,
      @required this.isDeposit,
      @required this.date,
      this.accountId,
      this.typeId,
      this.accountUrlId,
      this.typeUrlId});

  final int id;
  final String urlId;
  final String description;
  final double amount;
  final bool isDeposit;
  final String date;
  final int accountId;
  final int typeId;
  final String accountUrlId;
  final String typeUrlId;

  Map<String, dynamic> toMap() => {
        'id': id,
        'urlId': urlId,
        'description': description,
        'amount': amount,
        'isDeposit': isDeposit,
        'date': date,
        'accountId': accountId,
        'typeId': typeId,
        'accountUrlId': accountUrlId,
        'typeUrlId': typeUrlId
      };

  String toJson() {
    return json.encode({
      'fields': {
        'description': {'stringValue': description},
        'amount': {'doubleValue': amount},
        'isDeposit': {'booleanValue': isDeposit},
        'date': {'stringValue': date},
        'accountUrlId': {'stringValue': accountUrlId},
        'typeUrlId': {'stringValue': typeUrlId},
      }
    });
  }

  static List<Item> fromJson(String jsonString) {
    var map = json.decode(jsonString);
    if (map['documents'] == null) return [];
    List<Item> items = List<Item>();
    map['documents'].forEach((data) {
      var fields = data['fields'];
      items.add(Item(
        urlId: data['name'],
        description: fields['description']['stringValue'],
        amount: (fields['amount']['doubleValue']).toDouble(),
        isDeposit: fields['isDeposit']['booleanValue'],
        date: fields['date']['stringValue'],
        accountUrlId: fields['accountUrlId']['stringValue'],
        typeUrlId: fields['typeUrlId']['stringValue'],
      ));
    });
    return items;
  }

  factory Item.fromMap(Map<String, dynamic> map) => Item(
        id: map['id'],
        urlId: map['urlId'],
        description: map['description'],
        amount: map['amount'],
        isDeposit:
            map['isDeposit'] == 1 || map['isDeposit'] == true ? true : false,
        date: map['date'],
        accountId: map['accountId'],
        typeId: map['typeId'],
        accountUrlId: map['accountUrlId'],
        typeUrlId: map['typeUrlId'],
      );
}
