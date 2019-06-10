import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// database table and column names
final String tableAppointments = 'appointments';
final String columnId = '_id';
final String columnEventDate = 'eventdate';
final String columnNote = 'note';

// data model class
class Appointment {
  int id;
  String eventDate;
  String note;

  Appointment();

  // convenience constructor to create a Appointment object
  Appointment.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    eventDate = map[columnEventDate];
    note = map[columnNote];
  }

  // convenience method to create a Map from this Appointment object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnEventDate: eventDate, columnNote: note};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "demo.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableAppointments (
                $columnId INTEGER PRIMARY KEY,
                $columnEventDate TEXT NOT NULL,
                $columnNote TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:
  Future<int> insert(Appointment apm) async {
    Database db = await database;
    int id = await db.insert(tableAppointments, apm.toMap());
    return id;
  }

  Future<Appointment> queryAppointment(String date) async {
    Database db = await database;
    List<Map> maps = await db.query(tableAppointments,
        columns: [columnId, columnEventDate, columnNote],
        where: '$columnEventDate = ?',
        whereArgs: [date]);
    if (maps.length > 0) {
      return Appointment.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Appointment apm) async {
    Database db = await database;
    int numberOfChange = await db.update(tableAppointments, apm.toMap(),
        where: '$columnId = ?', whereArgs: [apm.id]);
    return numberOfChange;
  }

  Future<int> delete(String date) async {
    Database db = await database;
    int numberOfChange = await db.delete(tableAppointments,
        where: '$columnEventDate = ?', whereArgs: [date]);
    return numberOfChange;
  }
}
