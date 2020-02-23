import 'package:flutter/material.dart';
import 'package:mobilenewsreader/ArticleUtils/TimeUtils.dart';

class PubDate extends StatelessWidget {
  DateTime _pubDate;

  PubDate({String stringDate, DateTime date}) {
    if (stringDate != null) {
      _pubDate = TimeUtils().parseRssDate(stringDate);
    } else {
      _pubDate = date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      TimeUtils().formatDateTime(_pubDate),
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.body2.fontSize,
      ),
    );
  }
}
