class DetailOrder {
  String userName;
  int ticket;
  int totalPrice;
  String method;
  String? note;
  String status;
  String filmTitle;
  String scheduleTime;
  String? confirmedByName;

  DetailOrder({
    required this.userName,
    required this.ticket,
    required this.totalPrice,
    required this.method,
    this.note,
    required this.status,
    required this.filmTitle,
    required this.scheduleTime,
    this.confirmedByName,
  });

  factory DetailOrder.fromMap(Map<String, dynamic> map) {
    return DetailOrder(
      userName: map['user_name'],
      ticket: map['ticket'],
      totalPrice: map['total_price'],
      method: map['method'],
      note: map['note'],
      status: map['status'],
      filmTitle: map['film_title'],
      scheduleTime: map['schedule_time'],
      confirmedByName: map['confirmed_by_name'],
    );
  }
}
