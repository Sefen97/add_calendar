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
          title: const Text('Add Event to Calendar'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _addEvent(context),
              child: const Text(
                "Add Event",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addEvent(BuildContext context) async {
    final status = await Permission.calendar.request();

    if (status.isGranted) {
      final event = Event(
        title: 'Meeting with Client',
        description: 'Discuss project details.',
        location: '123 Main St, Anytown, USA',
        startDate: DateTime.now().add(const Duration(hours: 1)),
        endDate: DateTime.now().add(const Duration(hours: 2)),
        allDay: false,
      );

      final success = await Add2Calendar.addEvent2Cal(event);

      if (success) {
        debugPrint("Event added to calendar successfully!");
      } else {
        debugPrint('Failed to add event to calendar.');
      }
    } else if (status.isPermanentlyDenied) {
      debugPrint("Calendar permission denied.");
    } else {
      debugPrint("Calendar permission denied.");
    }
  }
}
