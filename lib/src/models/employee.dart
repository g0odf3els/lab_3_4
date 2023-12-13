import 'package:lab_3_4/src/abstract/icloneable.dart';

class Employee implements ICloneable {
  String firstName;
  String secondName;

  Employee(this.firstName, this.secondName);

    @override
    Employee clone() {
      return Employee(firstName, secondName);
    }
}