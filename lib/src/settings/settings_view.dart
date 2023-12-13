import 'package:flutter/material.dart';
import 'package:lab_3_4/src/models/campus.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key, required this.campus}) : super(key: key);

  static const routeName = '/settings';
  final Campus campus;

  @override
  Widget build(BuildContext context) {
    TextEditingController universityNameController =
        TextEditingController(text: campus.universityName);
    TextEditingController addressController =
        TextEditingController(text: campus.address);
    TextEditingController roomRentController =
        TextEditingController(text: campus.roomRent.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('University Name:'),
            TextFormField(
              controller: universityNameController,
              decoration: const InputDecoration(
                hintText: 'Enter university name',
              ),
            ),
            SizedBox(height: 16),
            const Text('Address:'),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: 'Enter address',
              ),
            ),
            SizedBox(height: 16),
            const Text('Room Rent:'),
            TextFormField(
              controller: roomRentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter room rent',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save the changes to the campus object
                campus.universityName = universityNameController.text;
                campus.address = addressController.text;
                campus.roomRent = int.parse(roomRentController.text);

                // You may want to navigate back or perform other actions here
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
