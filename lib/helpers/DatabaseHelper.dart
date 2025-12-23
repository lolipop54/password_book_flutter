import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/user.dart';

class Databasehelper {
  Databasehelper._internal();
  static final Databasehelper _instance = Databasehelper._internal();
  factory Databasehelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<dynamic> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'password_book.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // 用户表
    await db.execute('''
    CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        salt TEXT NOT NULL,
        password_hash TEXT NOT NULL,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    // 密码条目表
    await db.execute('''
      CREATE TABLE password_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        website TEXT,
        note TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<bool> hasUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('users');
    return result.isNotEmpty;
  }

  Future<User?> getUser(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getFirstUser() async{
    final db = await database;
    List<Map<String,dynamic>> firstUser = await db.query('users', limit: 1);
    if(firstUser.isNotEmpty){
      return User.fromMap(firstUser.first);
    }
    return null;

  }

}