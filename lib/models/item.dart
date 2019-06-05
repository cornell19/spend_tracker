import 'package:meta/meta.dart';

class Item {
  Item({
    @required this.id,
    @required this.description,
    @required this.amount,
    @required this.isDeposit,
    @required this.date,
    @required this.accountId,
    @required this.typeId,
  });

  final int id;
  final String description;
  final double amount;
  final bool isDeposit;
  final String date;
  final int accountId;
  final int typeId;

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'amount': amount,
        'isDeposit': isDeposit,
        'date': date,
        'accountId': accountId,
        'typeId': typeId
      };
  factory Item.fromMap(Map<String, dynamic> map) => Item(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      isDeposit:
          map['isDeposit'] == 1 || map['isDeposit'] == true ? true : false,
      date: map['date'],
      accountId: map['accountId'],
      typeId: map['typeId']);
}
