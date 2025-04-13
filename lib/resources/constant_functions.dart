import 'package:intl/intl.dart';

String getSevenDayRange() {
  final now = DateTime.now();
  final end = now.subtract(Duration(days: 6)); // 7-day range includes today

  final startDay = now.day;
  final endDay = end.day;

  final startMonth = DateFormat('MMMM').format(now);
  final endMonth = DateFormat('MMMM').format(end);

  if (startMonth == endMonth) {
    // Same month
    return '$endDay - $startDay $startMonth';
  } else {
    // Different months
    return '$endDay $endMonth - $startDay $startMonth';
  }
}

String getdateWithMoth() {
  final now = DateTime.now();

  final startDay = now.day;

  final startMonth = DateFormat('MMMM').format(now);

  return '$startDay$startMonth';
}

String getFormattedTime() {
  DateTime now = DateTime.now();
  // Create a DateFormat object to format time
  DateFormat timeFormat = DateFormat('hh:mm a');
  return timeFormat.format(now);
}
