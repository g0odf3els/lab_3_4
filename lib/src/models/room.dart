import 'package:lab_3_4/src/abstract/icloneable.dart';
import 'package:lab_3_4/src/models/student.dart';

class Room implements ICloneable {
  Room(this.roomNumber, [List<Student>? students]) : students = students ?? [];

  final int roomNumber;
  List<Student> students;

  @override
  Room clone() {
    return Room(roomNumber, List.from(students.map((e) => e.clone())));
  }
}