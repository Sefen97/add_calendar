import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Add event to calendar '),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                            color: Colors.blue,
                            onPressed: () => _addEvent(context),
                            child: const Text(
                              "Add Event",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  void _addEvent(BuildContext context) async {
    final status = await Permission.calendar.request();
    if (status.isGranted) {
      final event = Event(
        title: 'This is  title ',
        description: 'This is description ',
        location: 'This is location',
        startDate: DateTime.now().add(const Duration(minutes: 30)),
        endDate: DateTime.now().add(const Duration(minutes: 90)),
        allDay: false,
        // iosParams: const IOSParams(
        //   reminder: Duration(),
        //   url: 'https://www.example.com',
        // ),
        // androidParams: const AndroidParams(
        //   emailInvites: [],
        // ),
      );
      final success = await Add2Calendar.addEvent2Cal(event);
      if (success) {
        debugPrint("Event added to calendar successfully!");
      } else {
        debugPrint("Failed to add event to calendar.");
      }
    } else {
      await Permission.calendar.request();
      // openAppSettings();
    }
  }
}
