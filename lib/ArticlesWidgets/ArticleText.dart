import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobilenewsreader/ArticleUtils/ArticleCrawler.dart';
import 'package:webfeed/webfeed.dart';

class ArticleText extends StatefulWidget {
  const ArticleText({
    Key key,
    @required this.feed,
  }) : super(key: key);

  final RssItem feed;

  @override
  _ArticleTextState createState() => _ArticleTextState();
}

class _ArticleTextState extends State<ArticleText> {
  String articleText = "";
  @override
  void initState() {
    super.initState();
    void loadArticle() async {
      String article = await ArticleCrawler(widget.feed.link).getArticle();
      setState(() {
        this.articleText = article.length > 0 ? article : 'content not found';
      });
    }

    loadArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Html(data: articleText),
      ),
    );
  }
}
