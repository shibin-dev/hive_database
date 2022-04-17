import 'package:flutter_new_project/model/student.dart';
import 'package:hive/hive.dart';
class Boxes {
  static Box<Student> getStudents() =>
      Hive.box<Student>('students');  
}