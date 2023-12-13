import 'package:flutter/material.dart';
import 'package:lab_3_4/src/models/campus.dart';
import 'room_details_view.dart';
import 'package:lab_3_4/src/models/room.dart';

class RoomListView extends StatefulWidget {
  const RoomListView({
    Key? key,
    required this.campus,
  }) : super(key: key);

  static const routeName = '/';

  final Campus campus;

  @override
  _RoomListViewState createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
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
                _createRoom(widget.campus);
              },
              child: const Text('Add room'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: widget.campus.rooms.length,
              itemBuilder: (BuildContext context, int index) {
                final room = widget.campus.rooms[index];

                return ListTile(
                  title: Text('Room:  ${room.roomNumber}'),
                  leading: const Icon(
                    Icons.door_back_door_outlined,
                    size: 30.0,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoomDetailsView.routeName,
                      arguments: room,
                    );
                  },
                  onLongPress: () {
                    _showDeleteRoomDialog(room);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _createRoom(Campus campus) {
    TextEditingController roomNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Room'),
          content: Column(
            children: [
              const Text('Enter Room Number:'),
              TextField(
                controller: roomNumberController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String roomNumberText = roomNumberController.text;
                if (roomNumberText.isNotEmpty) {
                  int roomNumber = int.parse(roomNumberText);
                  setState(() {
                    campus.rooms.add(Room(roomNumber));
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteRoomDialog(Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Room'),
          content:
              Text('Are you sure you want to delete Room ${room.roomNumber}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.campus.rooms.remove(room);
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
