import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/student.dart';
import 'page/student_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox<Student>('students');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Hive Student Details App';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: StudentPage(),
      );
}
