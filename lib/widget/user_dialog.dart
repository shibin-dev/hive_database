import 'package:flutter/material.dart';

class UserDialog extends StatefulWidget {
  //final Transaction? transaction;
  final Function(
    String name,
    int age,
    //bool isExpense
  ) onClickedDone;

  const UserDialog({
    Key? key,
    //this.transaction,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  // bool isExpense = true;

  // @override
  // void initState() {
  //   super.initState();

  //   if (widget.transaction != null) {
  //     final transaction = widget.transaction!;

  //     nameController.text = transaction.name;
  //     amountController.text = transaction.amount.toString();
  //     isExpense = transaction.isExpense;
  //   }
  // }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isEditing = widget.transaction != null;
    const title =
        //isEditing ? 'Edit User' :
        'Add User';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildAge(),
              SizedBox(height: 8),
              //buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(
          context,
          //isEditing: isEditing
        ),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildAge() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter age',
        ),
        keyboardType: TextInputType.number,
        validator: (age) => age != null && int.tryParse(age) == null
            ? 'Enter a valid number'
            : null,
        controller: ageController,
      );

  // Widget buildRadioButtons() => Column(
  //       children: [
  //         RadioListTile<bool>(
  //           title: Text('Expense'),
  //           value: true,
  //           groupValue: isExpense,
  //           onChanged: (value) => setState(() => isExpense = value!),
  //         ),
  //         RadioListTile<bool>(
  //           title: Text('Income'),
  //           value: false,
  //           groupValue: isExpense,
  //           onChanged: (value) => setState(() => isExpense = value!),
  //         ),
  //       ],
  //     );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(
    BuildContext context,
    //{required bool isEditing}
  ) {
    const text =
        //isEditing ? 'Save' :
        'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final age = int.tryParse(ageController.text) ?? 0;
          print(age);
          widget.onClickedDone(
            name, age,
            //isExpense
          );

          Navigator.of(context).pop();
        }
      },
    );
  }
}
