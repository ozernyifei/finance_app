import 'package:finance_app/models/subscription.dart';
import 'package:finance_app/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';

class DBHelper {
  factory DBHelper() => _instance;
  DBHelper._internal();
  static final DBHelper _instance = DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // Initialize the database
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expense_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        category TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount REAL,
        frequency INTEGER, -- in days
        next_payment TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  // ----------------- Expense CRUD Operations -----------------

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('expenses', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ----------------- Subscription CRUD Operations -----------------

  Future<int> insertSubscription(Subscription subscription) async {
    final db = await database;
    return db.insert('subscriptions', subscription.toMap());
  }

  Future<List<Subscription>> getSubscriptions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('subscriptions', orderBy: 'next_payment ASC');
    return List.generate(maps.length, (i) {
      return Subscription.fromMap(maps[i]);
    });
  }

  Future<int> updateSubscription(Subscription subscription) async {
    final db = await database;
    return db.update(
      'subscriptions',
      subscription.toMap(),
      where: 'id = ?',
      whereArgs: [subscription.id],
    );
  }

  Future<int> deleteSubscription(int id) async {
    final db = await database;
    return db.delete(
      'subscriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ----------------- User CRUD Operations -----------------

  Future<int> insertUser(User user) async {
    final db = await database;
    return db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
