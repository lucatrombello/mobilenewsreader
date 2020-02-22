import 'package:flutter/material.dart';
import 'package:mobilenewsreader/ArticleUtils/TimeFormatting.dart';
import 'package:mobilenewsreader/ArticlesWidgets/ArticleText.dart';
import 'package:mobilenewsreader/ArticlesWidgets/ArticleTitle.dart';
import 'package:webfeed/webfeed.dart';

class ReadArticlePage extends StatelessWidget {
  final RssItem feed;
  ReadArticlePage(this.feed);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feed.source.value),
      ),
      body: Column(
        children: <Widget>[
          ArticleTitle(feed: feed),
          Text(TimeFormatting().formatDateString(feed.pubDate)),
          ArticleText(feed: feed)
        ],
      ),
    );
  }
}
