import 'package:intl/intl.dart';

class TimeFormatting {
  static DateFormat rssDateFormat = DateFormat('EEE, dd MMM yyyy hh:mm');
  static DateFormat todayDateFormat = DateFormat('H:mm');
  static DateFormat pastDateFormat = DateFormat('dd MMM H:mm');

  String formatDateString(String date) {
    final DateTime originalDate = rssDateFormat.parseUTC(date).toLocal();
    final DateTime now = DateTime.now();
    final DateTime lastMidnight = new DateTime(now.year, now.month, now.day);
    return lastMidnight.isBefore(originalDate)
        ? todayDateFormat.format(originalDate)
        : pastDateFormat.format(originalDate);
  }

  String formatDateTime(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime lastMidnight = new DateTime(now.year, now.month, now.day);
    return lastMidnight.isBefore(date)
        ? todayDateFormat.format(date)
        : pastDateFormat.format(date);
  }
}
