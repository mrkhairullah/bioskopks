import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'bioskopks.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            password TEXT,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
      await db.execute('''
          CREATE TABLE films (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            director TEXT,
            rating TEXT,
            language TEXT,
            subtitle TEXT,
            trailer TEXT,
            poster TEXT,
            genre TEXT,
            duration TEXT,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
      await db.execute('''
          CREATE TABLE studios (
            id INTEGER PRIMARY KEY,
            name TEXT,
            max_seat INTEGER,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
      await db.execute('''
          CREATE TABLE schedules (
            id INTEGER PRIMARY KEY,
            film_id INTEGER,
            studio_id INTEGER,
            time TEXT,
            price INTEGER,
            available INTEGER,
            created_at TEXT,
            updated_at TEXT,
            FOREIGN KEY (film_id) REFERENCES films (id),
            FOREIGN KEY (studio_id) REFERENCES studios (id)
          )
        ''');
      await db.execute('''
          CREATE TABLE studio_capacities (
            id INTEGER PRIMARY KEY,
            studio_id INTEGER,
            schedule_id INTEGER,
            seat INTEGER,
            created_at TEXT,
            updated_at TEXT,
            FOREIGN KEY (studio_id) REFERENCES studios (id),
            FOREIGN KEY (schedule_id) REFERENCES schedules (id)
          )
        ''');
      await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            user_id INTEGER,
            film_id INTEGER,
            schedule_id INTEGER,
            ticket INTEGER,
            total_price INTEGER,
            method TEXT,
            note TEXT,
            payment_proof TEXT,
            status TEXT,
            confirmed_by INTEGER,
            created_at TEXT,
            updated_at TEXT,
            confirmed_at TEXT,
            FOREIGN KEY (user_id) REFERENCES users (id),
            FOREIGN KEY (film_id) REFERENCES films (id),
            FOREIGN KEY (schedule_id) REFERENCES schedules (id)
          )
        ''');
      await db.execute('''
          CREATE TABLE order_seats (
            id INTEGER PRIMARY KEY,
            order_id INTEGER,
            seat TEXT,
            created_at TEXT,
            updated_at TEXT,
            FOREIGN KEY (order_id) REFERENCES orders (id)
          )
        ''');

      // Data: Users
      await db.insert('users', {
        'name': 'Admin',
        'email': 'admin@bks.com',
        'password': '123',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });
      await db.insert('users', {
        'name': 'Dadang Mulyana',
        'email': 'dadang@gmail.com',
        'password': '123',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });

      // Data: Films
      await db.insert('films', {
        'title': 'Venom: The Last Dance',
        'description':
            'Eddie dan Venom kini sedang diburu. Dengan semakin dekatnya mereka, keduanya bersatu dan terpaksa mengambil keputusan berat. Apakah kali ini Eddie dan Venom akan berpisah?',
        'director': 'Kelly Marcel',
        'rating': 'R13+',
        'language': 'English',
        'subtitle': 'Indonesia',
        'trailer':
            'https://www.youtube.com/embed/__2bjWbetsA?si=XiZb1kQ31RIvpX_S',
        'poster':
            'https://m.media-amazon.com/images/M/MV5BZDMyYWU4NzItZDY0MC00ODE2LTkyYTMtMzNkNDdmYmFhZDg0XkEyXkFqcGc@._V1_FMjpg_UX1080_.jpg',
        'genre': 'Action',
        'duration': '109',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });
      await db.insert('films', {
        'title': 'Kuasa Gelap',
        'description':
            'Setelah kematian ibu dan adiknya dalam kecelakaan tragis, Thomas (Jerome Kurnia) bermaksud mengundurkan diri sebagai Romo. Namun dirinya justru diberi tugas terakhir untuk membantu Romo eksorsis, Rendra (Lukman Sardi), yang kesehatannya kian menurun, untuk mengusir iblis yang merasuki Kayla (Lea Ciarachel), sahabat mendiang adiknya. Thomas dan Rendra berusaha sekuat tenaga untuk mengusir iblis yang bersemayam dalam tubuh Kayla. Ternyata sosok iblis itu sangat kuat. Bukan saja mengancam nyawa Kayla tetapi juga Maya (Astrid Tiar), ibu Kayla yang menyimpan masa lalu gelap hingga membuatnya dikejar rasa bersalah. Kuasa Gelap adalah film horor pertama di Indonesia yg mengangkat ritual Gereja Katolik berdasarkan kasus nyata Eksorsisme.',
        'director': 'Bobby Prasetyo',
        'rating': 'D17+',
        'language': 'Indonesia',
        'subtitle': 'Indonesia',
        'trailer': 'https://www.youtube.com/embed/sMkUS1wqr8Q',
        'poster':
            'https://m.media-amazon.com/images/M/MV5BMmVhMTUzZjQtZTY0My00MDE2LWFkN2ItMDk4OTI1MWVkYmYyXkEyXkFqcGc@._V1_FMjpg_UX1080_.jpg',
        'genre': 'Horror',
        'duration': '96',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });

      // Data: Studios
      await db.insert('studios', {
        'name': 'Studio 1',
        'max_seat': 100,
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });
      await db.insert('studios', {
        'name': 'Studio 2',
        'max_seat': 80,
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });

      // Data: Schedules
      await db.insert('schedules', {
        'film_id': 1,
        'studio_id': 1,
        'time': DateTime.now().toString(),
        'price': 25000,
        'available': 'Selesai',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });
      await db.insert('schedules', {
        'film_id': 1,
        'studio_id': 2,
        'time': DateTime(2024, 12, 15, 09, 00, 0).toString(),
        'price': 20000,
        'available': 'Tersedia',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });
      await db.insert('schedules', {
        'film_id': 2,
        'studio_id': 1,
        'time': DateTime(2024, 12, 25, 14, 30, 0).toString(),
        'price': 20000,
        'available': 'Tersedia',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });

      // Data: Studio Capacities
      await db.insert('studio_capacities', {
        'studio_id': 1,
        'schedule_id': 1,
        'seat': 40,
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });
      await db.insert('studio_capacities', {
        'studio_id': 2,
        'schedule_id': 2,
        'seat': 24,
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });

      // Data: Payments
      await db.insert('orders', {
        'user_id': 2,
        'film_id': 1,
        'schedule_id': 2,
        'ticket': 2,
        'total_price': 40000,
        'method': 'Transfer Bank',
        'note': null,
        'payment_proof': null,
        'status': 'Pending',
        'confirmed_by': null,
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });

      // Data: Order Seats
      await db.insert('order_seats', {
        'order_id': 1,
        'seat': 'A1',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });
      await db.insert('order_seats', {
        'order_id': 1,
        'seat': 'B1',
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),
      });
    } catch (e) {
      print('Error! $e');
    }
  }
}
