import 'package:lab_3_4/src/models/employee.dart';
import 'package:lab_3_4/src/models/room.dart';
import 'package:lab_3_4/src/models/student.dart';
import 'package:lab_3_4/src/abstract/icloneable.dart';

class Campus extends ICloneable {
  String universityName;
  String address;
  int roomRent;
  bool canteen = false;

  List<Room> rooms = [];
  List<Employee> employees = [];

  int get roomsNumber {
    return rooms.length;
  }

  int get employeesNumber {
    return employees.length + (canteen == false ? 0 : 5);
  }

  Campus(this.universityName, this.address, this.roomRent, this.rooms,
      [List<Employee>? employees])
      : employees = employees ?? [];

  void addRoom(Room room) {
    rooms.add(room);
  }

  void removeRoom(Room room) {
    rooms.remove(room);
  }

  void eviction(Student student) {
    rooms
        .firstWhere((element) => element.students.contains(student))
        .students
        .remove(student);
  }

  void accommodation(int roomNumber, Student student) {
    rooms
        .firstWhere((element) => element.roomNumber == roomNumber)
        .students
        .add(student);
  }

  double calculateIncome(int numberOfMonths) {
    var students = 0;
    for (var i = 0; i < rooms.length; i++) {
      students += rooms[i].students.length;
    }

    return (students *
            roomRent *
            numberOfMonths *
            (canteen == false ? 1 : 1.20))
        .toDouble();
  }

  @override
  String toString() {
    return "${universityName}, ${address}";
  }

  @override
  Campus clone() {
    Campus clonedCampus = Campus(
        universityName,
        address,
        roomRent,
        List.from(rooms.map((e) => e.clone())),
        List.from(employees.map((e) => e.clone)));
    return clonedCampus;
  }
}
