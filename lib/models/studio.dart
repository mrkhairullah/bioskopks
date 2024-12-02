class Studio {
  int? id;
  String name;
  String maxSeat;

  Studio({
    this.id,
    required this.name,
    required this.maxSeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'max_seat': maxSeat,
    };
  }

  factory Studio.fromMap(Map<String, dynamic> map) {
    return Studio(
      id: map['id'],
      name: map['name'],
      maxSeat: map['max_seat'],
    );
  }
}
