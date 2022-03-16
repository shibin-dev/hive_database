import 'package:flutter/material.dart';
import 'package:flutter_new_project/widget/user_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../boxes.dart';
import '../model/transaction.dart';
import '../widget/transaction_dialog.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    Hive.box('transactions').close();
    Hive.box('users').close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(controller.index == 0 ? 'Hive Expense Tracker' : 'Users'),
        centerTitle: true,
        bottom: TabBar(controller: controller, tabs: const [
          Tab(
            text: 'Tracker',
          ),
          Tab(
            text: 'Users',
          ),
        ]),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          firstTab(),
          secondTab(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            controller.index == 0
                ? const SizedBox()
                : FloatingActionButton(
                    onPressed: () {}, child: const Icon(Icons.delete_forever)),
            const SizedBox(
              width: 5,
            ),
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => controller.index == 0
                    ? TransactionDialog(
                        onClickedDone: addTransaction,
                      )
                    : UserDialog(onClickedDone: addUser),
              ),
            ),
          ],
        ),
      ));

  Widget firstTab() {
    return ValueListenableBuilder<Box<Transaction>>(
      valueListenable: Boxes.getTransactions().listenable(),
      builder: (context, box, _) {
        final transactions = box.values.toList().cast<Transaction>();
        return buildContent(transactions);
      },
    );
  }

  Widget secondTab() {
    return ValueListenableBuilder<Box<User>>(
        valueListenable: Boxes.getUsers().listenable(),
        builder: (context, box, _) {
          final users = box.values.toList().cast<User>();
          return buildContent2(users);
        });
  }

  Widget buildContent(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No expenses yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      final netExpense = transactions.fold<double>(
        0,
        (previousValue, transaction) => transaction.isExpense
            ? previousValue - transaction.amount
            : previousValue + transaction.amount,
      );
      final newExpenseString = '\$${netExpense.toStringAsFixed(2)}';
      final color = netExpense > 0 ? Colors.green : Colors.red;

      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Net Expense: $newExpenseString',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = transactions[index];

                return buildTransaction(context, transaction);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildContent2(List<User> users) {
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No users yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          return buildUser(context, user);
        },
      );
    }
  }

  Widget buildTransaction(
    BuildContext context,
    Transaction transaction,
  ) {
    final color = transaction.isExpense ? Colors.red : Colors.green;
    final date = DateFormat.yMMMd().format(transaction.createdDate);
    final amount = '\$' + transaction.amount.toStringAsFixed(2);

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          transaction.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, transaction),
        ],
      ),
    );
  }

  Widget buildUser(
    BuildContext context,
    User user,
  ) {
    final color = Colors.green;
    final name = user.name;
    final age = user.age;

    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text("$age"),
      ),
    );
  }

  Widget buildButtons(BuildContext context, Transaction transaction) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () =>
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  showDialog(
                context: context,
                builder: (context) => TransactionDialog(
                  transaction: transaction,
                  onClickedDone: (name, amount, isExpense) =>
                      editTransaction(transaction, name, amount, isExpense),
                ),
              ),
              //  ),
              // ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteTransaction(transaction),
            ),
          )
        ],
      );

  Future addTransaction(String name, double amount, bool isExpense) async {
    final transaction = Transaction()
      ..name = name
      ..createdDate = DateTime.now()
      ..amount = amount
      ..isExpense = isExpense;

    final box = Boxes.getTransactions();
    box.add(transaction);
    //box.put('mykey', transaction);

    // final mybox = Boxes.getTransactions();
    // final myTransaction = mybox.get('key');
    // mybox.values;
    // mybox.keys;
  }

  Future addUser(String name, int age) async {
    final user = User()
      ..name = name
      ..age = age;
    final box = Boxes.getUsers();
    box.add(user);
  }

  void editTransaction(
    Transaction transaction,
    String name,
    double amount,
    bool isExpense,
  ) {
    transaction.name = name;
    transaction.amount = amount;
    transaction.isExpense = isExpense;

    // final box = Boxes.getTransactions();
    // box.put(transaction.key, transaction);

    transaction.save();
  }

  void deleteTransaction(Transaction transaction) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);

    transaction.delete();
    //setState(() => transactions.remove(transaction));
  }
}
