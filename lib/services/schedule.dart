import '../models/schedule.dart';
import 'db.dart';

class ScheduleService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> createSchedule(Schedule schedule) async {
    final db = await _dbService.database;
    return await db.insert('schedules', schedule.toMap());
  }

  Future<List<Schedule>> getSchedules() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('schedules');
    return maps.map((map) => Schedule.fromMap(map)).toList();
  }

  Future<Schedule?> getScheduleById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query('schedules', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Schedule.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateSchedule(Schedule schedule) async {
    final db = await _dbService.database;
    return await db.update(
      'schedules',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<int> deleteSchedule(int id) async {
    final db = await _dbService.database;
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }
}
