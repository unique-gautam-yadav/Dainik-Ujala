import 'dart:developer';

import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class SqliteServices {
  SqliteServices() {
    log("Performing something in sqlite");
  }
  Future<Database> initizateDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'sys.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Advts (id TEXT)");
      },
      version: 1,
    );
  }

  insertAdvt({required String id}) async {
    final db = await initizateDb();
    db.insert('Advts', {'id': id});
  }

  Future<bool> chechAdvt({required String id}) async {
    final db = await initizateDb();
    var temp = await db.query('Advts', where: "id = ?", whereArgs: [id]);
    if (temp.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
