import 'package:budget_app/data/datasources/table_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final dbHelperProvider = StateNotifierProvider<DatabaseHelper, Database?>((_) {
  return DatabaseHelper(null);
});

class DatabaseHelper extends StateNotifier<Database?> {
  DatabaseHelper(super.state);
  static const String budgetTable = TableName.budget;
  static const String transactionTable = TableName.transaction;
  static const String userTable = TableName.user;

  static const _databaseName = "app.db";
  static const _databaseVersion = 1;

  Database get db {
    if (state == null) {
      throw Exception('Database has not been initialized yet.');
    }
    return state!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    await deleteDatabase(path);
    Database database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    state = database;
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $budgetTable (
      id TEXT PRIMARY KEY,
      userId TEXT,
      name TEXT,
      iconId INTEGER,
      currentAmount INTEGER,
      budgetLimit INTEGER,
      budgetTypeValue TEXT,
      rangeDateTimeTypeValue TEXT,
      startDate INTEGER,
      endDate INTEGER,
      createdDate INTEGER,
      updatedDate INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE $transactionTable (
      id TEXT PRIMARY KEY,
      userId TEXT,
      budgetId TEXT,
      amount INTEGER,
      note TEXT,
      transactionTypeValue TEXT,
      createdDate INTEGER,
      transactionDate INTEGER,
      updatedDate INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE $userTable (
      id TEXT PRIMARY KEY,
      email TEXT,
      profileUrl TEXT,
      name TEXT,
      accountTypeValue TEXT,
      currencyTypeValue TEXT,
      balance INTEGER,
      phoneNumber TEXT,
      token TEXT,
      role TEXT,
      languageCode TEXT,
      isRemindTransactionEveryDate INTEGER,
      createdDate INTEGER,
      updatedDate INTEGER
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {}
  }

  Future close() async {
    state?.close();
    state = null;
  }
}
