import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SleepDatabase {
  static final SleepDatabase instance = SleepDatabase._init();
  static Database? _database;
  SleepDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sleep.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sleeps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start INTEGER NOT NULL,
        end INTEGER NOT NULL,
        quality INTEGER
      )
    ''');
  }

  Future<int> insertSleep(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('sleeps', row);
  }

  Future<List<Map<String, dynamic>>> fetchLastNDays(int days) async {
    final db = await instance.database;
    final since = DateTime.now().subtract(Duration(days: days)).millisecondsSinceEpoch;
    return await db.query('sleeps', where: 'start >= ?', whereArgs: [since]);
  }
}
