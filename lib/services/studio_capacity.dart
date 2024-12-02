import '../models/studio_capacity.dart';
import 'db.dart';

class StudioCapacityService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> createStudioCapacity(StudioCapacity studioCapacity) async {
    final db = await _dbService.database;
    return await db.insert('studio_capacities', studioCapacity.toMap());
  }

  Future<List<StudioCapacity>> getStudioCapacities() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('studio_capacities');
    return maps.map((map) => StudioCapacity.fromMap(map)).toList();
  }

  Future<StudioCapacity?> getStudioCapacityById(int id) async {
    final db = await _dbService.database;
    final maps =
        await db.query('studio_capacities', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return StudioCapacity.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateStudioCapacity(StudioCapacity studioCapacity) async {
    final db = await _dbService.database;
    return await db.update(
      'studio_capacities',
      studioCapacity.toMap(),
      where: 'id = ?',
      whereArgs: [studioCapacity.id],
    );
  }

  Future<int> deleteStudioCapacity(int id) async {
    final db = await _dbService.database;
    return await db
        .delete('studio_capacities', where: 'id = ?', whereArgs: [id]);
  }
}
