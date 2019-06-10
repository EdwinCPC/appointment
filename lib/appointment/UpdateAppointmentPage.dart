import 'package:appointment/database/database_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateAppointmentPage extends StatefulWidget {
  final Appointment apm;

  UpdateAppointmentPage({Key key, @required this.apm}) : super(key: key);

  @override
  _UpdateAppointmentPageState createState() => _UpdateAppointmentPageState();
}

class _UpdateAppointmentPageState extends State<UpdateAppointmentPage> {
  String selectedDate;
  var _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedDate = widget.apm.eventDate;
    _controller.text = widget.apm.note;
    return new Scaffold(
      appBar: new AppBar(
          automaticallyImplyLeading: true,
          title: new Text('Appointment'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.delete, color: Colors.white),
              tooltip: "Delete",
              onPressed: _onDeletePress,
            ),
            new IconButton(
              icon: new Icon(Icons.update, color: Colors.white),
              tooltip: "Update",
              onPressed: _onUpdatePress,
            )
          ]),
      body: new Container(
        child: new Column(mainAxisSize: MainAxisSize.max, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(selectedDate.substring(0, 4) +
                ' - ' +
                selectedDate.substring(4, 6) +
                ' - ' +
                selectedDate.substring(6, 8)),
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

  void _onUpdatePress() {
    String notes = _controller.text;
    if (notes.isEmpty) {
      _controller.text = 'New Appointment';
    }
    _update();
  }

  _update() async {
    Appointment apm = Appointment();
    apm.id = widget.apm.id;
    apm.eventDate = widget.apm.eventDate;
    apm.note = _controller.text;
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.update(apm);
    print('update row: $id');
    Navigator.pop(context);
  }

  void _onDeletePress() {
    _delete();
  }

  _delete() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.delete(widget.apm.eventDate);
    print('delete row: $id');
    Navigator.pop(context);
  }
}
