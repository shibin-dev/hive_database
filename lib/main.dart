import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/transaction.dart';
import 'page/transaction_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TransactionAdapter().typeId)) {
    Hive.registerAdapter(TransactionAdapter());
  }
  if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
    Hive.registerAdapter(UserAdapter());
  }
  await Hive.openBox<Transaction>(
      'transactions'); //transactions is our database name
  await Hive.openBox<User>('users');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Hive Expense App';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: TransactionPage(),
      );
}
