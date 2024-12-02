class DetailSchedule {
  int scheduleId;
  int filmId;
  int studioId;
  String time;
  int price;
  String available;
  String filmTitle;
  String studioName;
  int studioMaxSeat;
  int studioCapacitySeat;

  DetailSchedule({
    required this.scheduleId,
    required this.filmId,
    required this.studioId,
    required this.time,
    required this.price,
    required this.available,
    required this.filmTitle,
    required this.studioName,
    required this.studioMaxSeat,
    required this.studioCapacitySeat,
  });

  factory DetailSchedule.fromMap(Map<String, dynamic> map) {
    return DetailSchedule(
      scheduleId: map['id'],
      filmId: map['film_id'],
      studioId: map['studio_id'],
      time: map['time'],
      price: map['price'],
      available: map['available'],
      filmTitle: map['film_title'],
      studioName: map['studio_name'],
      studioMaxSeat: map['studio_max_seat'],
      studioCapacitySeat: map['studio_capacity_seat'],
    );
  }
}
