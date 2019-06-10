import 'package:appointment/database/database_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAppointmentPage extends StatefulWidget {
  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  DateTime selectedDate = DateTime.now();
  var _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 6),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          automaticallyImplyLeading: true,
          title: new Text('Add Appointment'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.save, color: Colors.white),
              tooltip: "Save",
              onPressed: _onSavePress,
            )
          ]),
      body: new Container(
        child: new Column(mainAxisSize: MainAxisSize.max, children: [
          new InkWell(
            onTap: () => _selectDate(context),
            child: new Padding(
              padding: new EdgeInsets.all(20.0),
              child:
                  new Text(DateFormat('yyyy - MM - dd').format(selectedDate)),
            ),
          ),
          new Divider(),
          new TextField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            maxLines: 12,
            decoration: new InputDecoration(
              border: InputBorder.none,
              contentPadding: new EdgeInsets.all(10),
              hintText: 'Notes',
            ),
          ),
        ]),
      ),
    );
  }

  void _onSavePress() {
    String notes = _controller.text;
    if (notes.isNotEmpty) {
      _checkDate(DateFormat('yyyyMMdd').format(selectedDate));
    }
  }

  _save(String date) async {
    Appointment apm = Appointment();
    apm.eventDate = date;
    apm.note = _controller.text;
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(apm);
    print('inserted row: $id');
    Navigator.pop(context);
  }

  _checkDate(String date) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    Appointment apm = await helper.queryAppointment(date);
    if (apm == null) {
      print('read row $date: empty');
      _save(date);
    } else {
      print('read row $date: ${apm.id} ${apm.note}');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('An appointment has already been made on this day.'),
          );
        },
      );
    }
  }
}
