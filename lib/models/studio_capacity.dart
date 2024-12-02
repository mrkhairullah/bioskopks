class StudioCapacity {
  int? id;
  int studioId;
  int scheduleId;
  int seat;

  StudioCapacity({
    this.id,
    required this.studioId,
    required this.scheduleId,
    required this.seat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studio_id': studioId,
      'schedule_id': scheduleId,
      'seat': seat,
    };
  }

  factory StudioCapacity.fromMap(Map<String, dynamic> map) {
    return StudioCapacity(
      id: map['id'],
      studioId: map['studio_id'],
      scheduleId: map['schedule_id'],
      seat: map['seat'],
    );
  }
}
