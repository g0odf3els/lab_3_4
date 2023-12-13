import 'package:flutter/material.dart';
import 'package:lab_3_4/src/models/campus.dart';

class GeneralDetails extends StatefulWidget {
  const GeneralDetails({
    Key? key,
    required this.campus,
  }) : super(key: key);

  static const routeName = '/GeneralDetails';

  final Campus campus;

  @override
  _GeneralDetailsState createState() => _GeneralDetailsState();
}

class _GeneralDetailsState extends State<GeneralDetails>
    with SingleTickerProviderStateMixin {
  late int customPeriod;
  double income = 0;
  bool _canteenSwitchValue = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    customPeriod = 1;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _offsetAnimation =
        Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Campus Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(
                    'Total Rooms', widget.campus.roomsNumber.toString()),
                const SizedBox(height: 10),
                _buildDetailItem('Total Employees',
                    widget.campus.employeesNumber.toString()),
                const SizedBox(height: 20),
                Row(children: [
                  Text('Canteen'),
                  Switch(
                    value: _canteenSwitchValue,
                    onChanged: (value) {
                      setState(() {
                        _canteenSwitchValue = value;
                        widget.campus.canteen = value;
                      });
                    },
                  ),
                ]),
                const SizedBox(height: 20),
                _buildIncomeArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Income',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  customPeriod = int.tryParse(value) ?? 0;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Period (months)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: double.infinity,
              child: ElevatedButton(
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
                  income = widget.campus.calculateIncome(customPeriod);
                  setState(() {});
                },
                child: const Text(
                  'Calculate Income',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        if (income > 0)
          Text(
            'Total Income for $customPeriod months: $income',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
      ],
    );
  }
}
