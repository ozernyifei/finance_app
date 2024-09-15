import 'dart:convert';

import 'package:crypto/crypto.dart';


import 'db_helper.dart';

class AuthService {
  final DBHelper _dbHelper = DBHelper();

  // Hash password for security
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> register(String username, String password) async {
    final hashedPassword = _hashPassword(password);
    try {
      await _dbHelper.database.then((db) {
        return db.insert('users', {
          'username': username,
          'password': hashedPassword,
        });
      });
      return true;
    } catch (e) {
      //TODO: Handle unique constraint violation or other errors
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    final hashedPassword = _hashPassword(password);
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );
    return maps.isNotEmpty;
  }
}
