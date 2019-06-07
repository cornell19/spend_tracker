import 'package:meta/meta.dart';

class Balance {
  Balance({
    @required this.withdraw,
    @required this.deposit,
    @required this.total,
  });

  final double withdraw;
  final double deposit;
  final double total;
}
