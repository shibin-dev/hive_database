import 'package:flutter/material.dart';
import 'package:flutter_new_project/model/student.dart';
import 'package:flutter_new_project/widget/student_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../boxes.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Hive Student Details Tracker'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Student>>(
          valueListenable: Boxes.getStudents().listenable(),
          builder: (context, box, _) {
            final students = box.values.toList().cast<Student>();
            return buildContent(students);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const StudentDialog(
              onClickedDone: addStudent,
            ),
          ),
        ),
      );

  Widget buildContent(List<Student> students) {
    if (students.isEmpty) {
      return const Center(
        child: Text(
          'No student yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: students.length,
            itemBuilder: (BuildContext context, int index) {
              final student = students[index];
              return buildStudent(context, student);
            },
          ),
        ),
      ],
    );
  }
}

Widget buildStudent(
  BuildContext context,
  Student student,
) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
    color: Colors.white,
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        "Name : ${student.name}",
        maxLines: 2,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text("Age : ${student.age}"),
      children: [
        buildButtons(context, student),
      ],
    ),
  );
}

Widget buildButtons(BuildContext context, Student student) => Row(
      children: [
        Expanded(
          child: TextButton.icon(
            label: const Text('Edit'),
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StudentDialog(
                  student: student,
                  onClickedDone: (name, age) =>
                      editTransaction(student, name, age),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            label: const Text('Delete'),
            icon: const Icon(Icons.delete),
            onPressed: () => deleteTransaction(student),
          ),
        )
      ],
    );

Future addStudent(String name, int age) async {
  final student = Student()
    ..name = name
    ..age = age;

  final box = Boxes.getStudents();
  box.add(student);
  //box.put('mykey', transaction);

  // final mybox = Boxes.getTransactions();
  // final myTransaction = mybox.get('key');
  // mybox.values;
  // mybox.keys;
}

void editTransaction(
  Student student,
  String name,
  int age,
) {
  student.name = name;
  student.age = age;
  // final box = Boxes.getTransactions();
  // box.put(transaction.key, transaction);

  student.save();
}

void deleteTransaction(Student student) {
  // final box = Boxes.getTransactions();
  // box.delete(transaction.key);

  student.delete();
  //setState(() => transactions.remove(transaction));
}
