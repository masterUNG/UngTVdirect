import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ungtvdirect/models/sqlite_model.dart';

class SqliteHelper {
  final String nameDatabase = 'tvd.db';
  int version = 1;
  final String tableDatabase = 'order';
  final String id = 'id';
  final String goodsCode = 'goodscode';
  final String goodName = 'goodsname';
  final String salsePrice = 'salseprice';
  final String amount = 'amount';
  final String sum = 'sum';

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableDatabase ($id INTEGER PRIMARY KEY, $goodsCode TEXT, $goodName TEXT, $salsePrice TEXT, $amount TEXT, $sum TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertValueToDatabase(SqliteModel model) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        tableDatabase,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('e InsertSQLite ==> ${e.toString()}');
    }
  }

  Future<List<SqliteModel>> readDatabase() async {
    Database database = await connectedDatabase();
    List<SqliteModel> sqliteModels = List();

    List<Map<String, dynamic>> maps = await database.query(tableDatabase);
    for (var map in maps) {
      SqliteModel model = SqliteModel.fromJson(map);
      sqliteModels.add(model);
    }

    return sqliteModels;
  }

  SqliteHelper() {
    initDatabase();
  }
}
