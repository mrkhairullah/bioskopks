import '../models/user.dart';
import 'db.dart';

class UserService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> createUser(User user) async {
    final db = await _dbService.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<User?> getUserById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int?> login(String email, String password) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'users',
      columns: ['id'],
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await _dbService.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await _dbService.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
