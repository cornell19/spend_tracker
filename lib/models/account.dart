import 'package:meta/meta.dart';

class Account {
  Account({
    @required this.id,
    @required this.name,
    @required this.codePoint,
    @required this.balance,
  });

  final int id;
  final String name;
  final int codePoint;
  final double balance;

  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'codePoint': codePoint, 'balance': balance};

  factory Account.fromMap(Map<String, dynamic> map) => Account(
        id: map['id'],
        name: map['name'],
        codePoint: map['codePoint'],
        balance: map['balance'],
      );
}
