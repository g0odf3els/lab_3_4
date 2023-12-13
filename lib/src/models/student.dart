import 'package:lab_3_4/src/abstract/icloneable.dart';

class Student implements ICloneable {
  String firstName;
  String secondName;

  Student(this.firstName, this.secondName);

    @override
    Student clone() {
      return Student(firstName, secondName);
  }
}
