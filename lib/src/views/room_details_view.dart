import 'package:flutter/material.dart';
import 'package:lab_3_4/src/models/room.dart';
import 'package:lab_3_4/src/models/student.dart';
import 'package:lab_3_4/src/models/campus.dart';

class RoomDetailsView extends StatefulWidget {
  const RoomDetailsView({Key? key, required this.campus, required this.room})
      : super(key: key);

  static const routeName = '/room';

  final Campus campus;
  final Room room;

  @override
  _RoomDetailsViewState createState() => _RoomDetailsViewState();
}

class _RoomDetailsViewState extends State<RoomDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room details - ${widget.room.roomNumber}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Container(
                width: double.infinity,
                child: FilledButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    _accommodateStudents(context);
                  },
                  child: const Text('Accommodate Students'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(-1.0, 0),
                end: Offset.zero,
              ).animate(_controller),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Students in Room:',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.room.students.length,
                itemBuilder: (context, index) {
                  return FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1.0, 0),
                        end: Offset.zero,
                      ).animate(_controller),
                      child: ListTile(
                        title: Text(
                            "${widget.room.students[index].firstName} ${widget.room.students[index].secondName}"),
                        leading: const Icon(
                          Icons.man,
                          size: 30.0,
                        ),
                        onTap: () {
                          _showStudentOptionsDialog(context, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStudentOptionsDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Student Options'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Evict Student'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _evictStudents(context, index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _accommodateStudents(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController secondNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accommodate Student'),
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
                    widget.room.students.add(Student(firstName, secondName));
                    _controller.forward(from: 0.0);
                  });
                  Navigator.of(context).pop();
                } else {
                  print("Please enter valid first name and second name");
                }
              },
              child: const Text('Accommodate'),
            ),
          ],
        );
      },
    );
  }

  void _evictStudents(BuildContext context, int index) {
    setState(() {
      if (widget.room.students.isNotEmpty &&
          index >= 0 &&
          index < widget.room.students.length) {
        widget.room.students.removeAt(index);
        _controller.forward(from: 0.0);
      }
    });
  }
}
