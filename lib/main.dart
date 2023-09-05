import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_calendar/device_calendar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  final cairoTimeZone = getLocation('Africa/Cairo');

  String? myEventId;
  String? myCalendarId;

  @override
  void initState() {
    super.initState();
  }

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => getCalendarId(),
                  child: const Text(
                    "Add Event",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if(myCalendarId != null || myEventId != null){
                      deleteCalendarEvent(myCalendarId,myEventId);
                    }
                  },
                  child: const Text(
                    "Delete Event",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getCalendarId() async {
    final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
    final calendarsResult = await deviceCalendarPlugin.retrieveCalendars();

    if (calendarsResult.isSuccess && calendarsResult.data!.isNotEmpty) {
      // Replace 'Your Calendar Name' with the name of the calendar you want to get the ID for.
      const calendarName = 'Phone';

      var foundCalendar;
      print('List of Calendars:');
      for (var calendar in calendarsResult.data!) {
        print('${calendar.name}: ${calendar.id}');
        if (calendar.name == calendarName) {
          // Store the calendar if it matches the specified name.
          foundCalendar = calendar;
          print("foundCalendarID:${foundCalendar.id}");
          break;
        }
      }

      if (foundCalendar != null) {
        final calendarId = foundCalendar.id;
        print('Calendar ID for $calendarName: $calendarId');
        myCalendarId = calendarId;
        createEvent(calendarId);
      } else {
        print('Calendar not found: $calendarName');
      }
    } else {
      print(
          'Error retrieving calendars: ${calendarsResult.errors.first.errorMessage}');
    }
  }

  Future<List<Calendar>> retrieveCalendars() async {
    try {
      var permissions = await _deviceCalendarPlugin.requestPermissions();
      if (!permissions.isSuccess || !permissions.data!) {
        // Handle permission denied
        return [];
      }

      var calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (calendarsResult.isSuccess) {
        List<Calendar> calendars = calendarsResult.data!;
        return calendars;
      } else {
        // Handle error
        return [];
      }
    } catch (e) {
      // Handle any exceptions
      return [];
    }
  }

  Future<String> createEvent(String? calendarId) async {
    try {
      var result = await _deviceCalendarPlugin.createOrUpdateEvent(Event(
        calendarId,
        title: "Meeting with Amr",
        location: "Cairo",
        description: "Sprint Planning Meeting",
        allDay: false,
        start: TZDateTime(cairoTimeZone, 2023, 9, 5, 12, 0),
        end: TZDateTime(cairoTimeZone, 2023, 9, 5, 14, 0),
      ));

      if (result!.isSuccess) {
        print("abaza isSuccess : ${result.data}");
        myEventId = result.data!;
        return result.data!;
      } else {
        // Handle error
        print("abaza errors : ${result.errors.first.errorMessage}");
        return "error";
      }
    } catch (e) {
      // Handle any exceptions
      print("abaza : Exception");
      return "Exception";
    }
  }

  Future<bool> deleteCalendarEvent(String? calendarId, String? eventId) async {
    try {
      var result = await _deviceCalendarPlugin.deleteEvent(calendarId, eventId);
      if (result.isSuccess) {
        // Event deletion was successful
        print("abaza :Event deleted was successful");
        return true;
      } else {
        // Handle error
        print("abaza :${result.errors.first.errorMessage}");
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      return false;
    }
  }
}
