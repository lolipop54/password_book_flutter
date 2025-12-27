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
    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
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
    // 通用设置表
    await db.execute('''
      CREATE TABLE common_settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        value TEXT NOT NULL,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 从版本1升级到版本2：添加common_settings表
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE common_settings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          key TEXT UNIQUE NOT NULL,
          value TEXT NOT NULL,
          created_at TEXT,
          updated_at TEXT
        )
      ''');
    }
  }

  //用户相关操作
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<int> updateUser(User entry) async {
    final db = await database;
    return await db.update(
      'users',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
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

  // 批量更新密码条目，用于修改主密码后重新加密所有密码项
  Future<void> batchUpdatePasswordEntries(List<PasswordEntry> entries) async {
    final db = await database;
    final batch = db.batch();
    for (final entry in entries) {
      batch.update(
        'password_entries',
        entry.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
    }
    await batch.commit(noResult: true);
  }

  // 通用设置相关操作
  Future<bool> getDarkMode() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'common_settings',
      where: 'key = ?',
      whereArgs: ['is_dark_mode'],
    );
    if (result.isNotEmpty) {
      return result.first['value'] == '1';
    }
    return false;
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> result = await db.query(
      'common_settings',
      where: 'key = ?',
      whereArgs: ['is_dark_mode'],
    );
    if (result.isNotEmpty) {
      await db.update(
        'common_settings',
        {
          'value': isDarkMode ? '1' : '0',
          'updated_at': now,
        },
        where: 'key = ?',
        whereArgs: ['is_dark_mode'],
      );
    } else {
      await db.insert(
        'common_settings',
        {
          'key': 'is_dark_mode',
          'value': isDarkMode ? '1' : '0',
          'created_at': now,
          'updated_at': now,
        },
      );
    }
  }
}
