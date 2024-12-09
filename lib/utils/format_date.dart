import 'package:intl/intl.dart';

String formatDate(String dateTime) {
  final formatter = DateFormat("d MMMM yyyy HH:mm 'WIB'", 'id_ID');

  return formatter.format(DateTime.parse(dateTime));
}
