import '../models/order.dart';
import '../models/order_history.dart';
import 'db.dart';

class OrderService {
  final DatabaseService _dbService = DatabaseService();

  Future<List<String>> getReservedSeats(int filmId, int scheduleId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT seat FROM order_seats
      INNER JOIN orders ON orders.id = order_seats.order_id
      WHERE orders.film_id = ? AND orders.schedule_id = ?
    ''', [filmId, scheduleId]);

    return maps.map((map) => map['seat'] as String).toList();
  }

  Future<int> createOrder(Order order) async {
    final db = await _dbService.database;
    return await db.insert('orders', order.toMap());
  }

  Future<List<Order>> getOrders(int? userId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('orders', where: 'user_id = ?', whereArgs: [userId]);
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<List<OrderHistory>> getOrderHistories(int userId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT
            orders.id AS order_id,
            orders.ticket AS ticket,
            orders.total_price AS total_price,
            orders.status AS status,
            films.title AS film_title,
            schedules.time AS schedule_time
          FROM orders
          INNER JOIN
            films ON orders.film_id = films.id
          INNER JOIN
            schedules ON orders.schedule_id = schedules.id
          WHERE
            orders.user_id = ?
        ''', [userId]);
    return maps.map((map) => OrderHistory.fromMap(map)).toList();
  }

  Future<Order?> getOrderById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query('orders', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Order.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateOrder(Order order) async {
    final db = await _dbService.database;
    return await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<int> deleteOrder(int id) async {
    final db = await _dbService.database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
