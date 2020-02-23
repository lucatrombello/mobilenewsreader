import 'package:intl/intl.dart';

class TimeUtils {
  static DateFormat rssDateFormat = DateFormat('EEE, dd MMM yyyy hh:mm');
  static DateFormat todayDateFormat = DateFormat('H:mm');
  static DateFormat pastDateFormat = DateFormat('dd MMM H:mm');

  String formatDateString(String date) {
    final DateTime originalDate = parseRssDate(date);
    return formatDateTime(originalDate);
  }

  String formatDateTime(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime lastMidnight = new DateTime(now.year, now.month, now.day);
    return lastMidnight.isBefore(date)
        ? todayDateFormat.format(date)
        : pastDateFormat.format(date);
  }

  int sortRssItemsByPubDate(item1, item2) =>
      parseRssDate(item2.pubDate).compareTo(
        parseRssDate(item1.pubDate),
      );

  DateTime parseRssDate(date) => rssDateFormat.parseUTC(date).toLocal();
}
