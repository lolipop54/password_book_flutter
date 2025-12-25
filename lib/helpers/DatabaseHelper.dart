import 'package:password_book_flutter/entity/PasswordEntry.dart';
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
        last_used_time TEXT,
        used_count INTEGER,
        mac TEXT NOT NULL,
        nonce TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  //用户相关操作
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

  Future<User?> getFirstUser() async {
    final db = await database;
    List<Map<String, dynamic>> firstUser = await db.query('users', limit: 1);
    if (firstUser.isNotEmpty) {
      return User.fromMap(firstUser.first);
    }
    return null;
  }

  // 密码条目相关操作
  Future<int> insertPasswordEntry(PasswordEntry entry) async {
    final db = await database;
    return await db.insert('password_entries', entry.toMap());
  }

  Future<List<PasswordEntry>> getAllPasswordEntries(int userId) async {
    final db = await database;
    var list = await db.query('password_entries', orderBy: 'created_at DESC', where: 'user_id = ?', whereArgs: [userId]);
    return list.map((e) => PasswordEntry.fromMap(e)).toList();
  }

  Future<List<PasswordEntry>> getPasswordEntry(int id) async {
    final db = await database;
    var list = await db.query('password_entries', where: 'id = ?', whereArgs: [id]);
    return list.map((e) => PasswordEntry.fromMap(e)).toList();
  }
  
  Future<PasswordEntry?> getPasswordEntryById(int id) async {
    final db = await database;
    var list = await db.query('password_entries', where: 'id = ?', whereArgs: [id]);
    if (list.isNotEmpty) {
      return PasswordEntry.fromMap(list.first);
    }
    return null;
  }


  Future<bool> deletePasswordEntry(int id) async {
    final db = await database;
    int rows_affected = await db.delete(
      'password_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows_affected > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> updatePasswordEntry(PasswordEntry entry) async {
    final db = await database;
    return await db.update(
      'password_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }
}
