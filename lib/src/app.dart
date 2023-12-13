import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lab_3_4/src/views/employees_list_view.dart';

import 'views/room_details_view.dart';
import 'views/general_details_view.dart';
import 'views/room_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'models/room.dart';
import 'models/campus.dart';

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;
  final Campus campus = Campus("Nure", "", 255, [Room(0), Room(1), Room(2)]);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,
            home: MyHomePage(campus: campus),
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                  settings: routeSettings,
                  builder: (BuildContext context) {
                    switch (routeSettings.name) {
                      case SettingsView.routeName:
                        return SettingsView(campus: campus);
                      case RoomDetailsView.routeName:
                        final Room room = routeSettings.arguments as Room;
                        return RoomDetailsView(campus: campus, room: room);
                      case RoomListView.routeName:
                      default:
                        return RoomListView(key: key, campus: campus);
                    }
                  });
            });
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.campus}) : super(key: key);
  final Campus campus;

  @override
  _MyHomePageState createState() => _MyHomePageState(campus);
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final Campus campus;
  late final List<Widget> _pages;

  _MyHomePageState(this.campus) {
    _pages = [
      GeneralDetails(campus: campus),
      RoomListView(campus: campus),
      EmployeesListView(campus: campus)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(campus.toString()),
            Spacer(),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_back_door),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Employees',
          ),
        ],
      ),
    );
  }
}
