import '../models/detail_schedule.dart';
import 'db.dart';

class DetailScheduleService {
  final DatabaseService _dbService = DatabaseService();

  Future<List<DetailSchedule>> getDetailSchedule(int filmId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        schedules.*,
        films.title AS film_title,
        studios.name AS studio_name,
        studios.max_seat AS studio_max_seat,
        studio_capacities.seat AS studio_capacity_seat
      FROM 
        schedules
      INNER JOIN 
        films ON schedules.film_id = films.id
      INNER JOIN 
        studios ON schedules.studio_id = studios.id
      INNER JOIN 
        studio_capacities ON schedules.studio_id = studio_capacities.studio_id
      WHERE 
        schedules.film_id = ?
    ''', [filmId]);
    return maps.map((map) => DetailSchedule.fromMap(map)).toList();
  }
}
