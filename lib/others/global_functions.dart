import 'package:intl/intl.dart';

String formatDateTime(String updateDate) {
  DateTime dateTime = DateTime.parse(updateDate);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCompare = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (dateToCompare == today) {
    return "Today";
  } else if (dateToCompare == yesterday) {
    return "Yesterday";
  } else {
    return DateFormat("MMM dd, yyyy").format(dateTime);
  }
}

String getInitial(String name) {
  String initial = name.substring(0, 1);
  return initial;
}
