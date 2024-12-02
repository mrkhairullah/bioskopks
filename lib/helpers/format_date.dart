import 'package:intl/intl.dart';

String formatDate(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat("d MMMM yyyy HH:mm 'WIB'", 'id_ID');
  return formatter.format(dateTime);
}
