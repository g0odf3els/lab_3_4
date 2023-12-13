import 'package:flutter/material.dart';
import 'package:lab_3_4/src/models/campus.dart';
import 'package:lab_3_4/src/models/employee.dart';

class EmployeesListView extends StatefulWidget {
  const EmployeesListView({
    Key? key,
    required this.campus,
  }) : super(key: key);

  static const routeName = '/Employees';

  final Campus campus;

  @override
  _EmployeesListViewState createState() => _EmployeesListViewState();
}

class _EmployeesListViewState extends State<EmployeesListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: FilledButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                _createEmployee(widget.campus);
              },
              child: const Text('Add employee'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: widget.campus.employees.length,
              itemBuilder: (BuildContext context, int index) {
                final employee = widget.campus.employees[index];

                return ListTile(
                  title: Text('${employee.firstName} ${employee.secondName}'),
                  leading: const Icon(
                    Icons.man,
                    size: 30.0,
                  ),
                  onTap: () {},
                  onLongPress: () {
                    _showDeleteRoomDialog(employee);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _createEmployee(Campus campus) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController secondNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a empoloyee'),
          content: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: secondNameController,
                decoration: InputDecoration(labelText: 'Second Name'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String firstName = firstNameController.text;
                String secondName = secondNameController.text;

                if (firstName.isNotEmpty && secondName.isNotEmpty) {
                  setState(() {
                    widget.campus.employees
                        .add(Employee(firstName, secondName));
                  });
                  Navigator.of(context).pop();
                } else {
                  print("Please enter valid first name and second name");
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteRoomDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Room'),
          content: Text(
              'Are you sure you want to hire employee ${employee.firstName} ${employee.secondName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.campus.employees.remove(employee);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
