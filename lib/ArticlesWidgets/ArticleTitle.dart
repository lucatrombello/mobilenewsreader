import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class ArticleTitle extends StatelessWidget {
  const ArticleTitle({
    Key key,
    @required this.feed,
  }) : super(key: key);

  final RssItem feed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        feed.title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
