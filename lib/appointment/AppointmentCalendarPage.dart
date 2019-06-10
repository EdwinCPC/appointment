import 'package:appointment/database/database_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:intl/intl.dart';

import 'AddAppointmentPage.dart';
import 'UpdateAppointmentPage.dart';

class AppointmentCalendarPage extends StatefulWidget {
  @override
  createState() => new AppointmentCalendarPageState();
}

class AppointmentCalendarPageState extends State<AppointmentCalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Appointment Calendar'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add),
              tooltip: "Add",
              onPressed: _pushAddEvent),
        ],
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Calendar(
              onSelectedRangeChange: (range) =>
                  print("Range is ${range.item1}, ${range.item2}"),
              onDateSelected: (date) =>
                  _checkDate(DateFormat('yyyyMMdd').format(date)),
            ),
          ],
        ),
      ),
    );
  }

  void _pushAddEvent() {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) => new AddAppointmentPage()));
  }

  _checkDate(String date) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    Appointment apm = await helper.queryAppointment(date);
    if (apm == null) {
      print('read row $date: empty');
      //No appointment on this day.
    } else {
      print('read row $date: ${apm.id} ${apm.note}');
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => new UpdateAppointmentPage(apm: apm)));
    }
  }
}
