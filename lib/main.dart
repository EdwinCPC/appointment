import 'package:flutter/material.dart';

import 'appointment/AppointmentCalendarPage.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppointmentCalendarPage(),
    );
  }
}