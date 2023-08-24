import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add event to calendar example'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Add normal event'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final status = await Permission.calendar.request();
                if (status.isGranted) {
                  final event = Event(
                    title: 'Test Event',
                    description: 'This is an example event',
                    location: 'sjd',
                    startDate: DateTime.now().add(const Duration(minutes: 30)),
                    endDate: DateTime.now().add(const Duration(minutes: 90)),
                    allDay: false,
                  );

                  final success = await Add2Calendar.addEvent2Cal(event);
                  if (success) {
                    print("Event added to calendar successfully!");
                  } else {
                    print("Failed to add event to calendar.");
                  }
                } else {
                  print("Calendar permission denied.");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
