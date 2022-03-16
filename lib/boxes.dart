import 'package:hive/hive.dart';

import 'model/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transactions');
  static Box<User> getUsers() => Hive.box<User>('users');
}
