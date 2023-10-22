import 'package:sqflite/sqflite.dart';

class Db {
  Database? _database;

  Future<void> initDb() async {
    _database = await openDatabase(
      'video.db',
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE kv(
            key TEXT,
            value TEXT
          )
        ''');
      },
    );
  }

  Future<void> insert(String key, String value) async {
    // Insert
    await _database!.insert('kv', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> get(String key) async {
    var res = await _database!.query('kv', where: 'key = ?', whereArgs: [key]);
    if (res.isEmpty) {
      return null;
    }
    return (res.first as Map<String, dynamic>)['value'];
  }
}

final Db SqliteDb = Db();