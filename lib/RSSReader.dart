import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:mobilenewsreader/Article.dart';
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';

class RSSReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'titolo',
      home: Articles(),
    );
  }
}

class Articles extends StatefulWidget {
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  RssFeed _rssFeed;

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() async {
    http.Response response =
        await http.get('https://news.google.com/rss?hl=it');
    if (response.statusCode == 200) {
      setState(() {
        _rssFeed = new RssFeed.parse(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSS'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.update,
            ),
            onPressed: update,
          )
        ],
      ),
      body: buildArticlesList(),
    );
  }

  ListView buildArticlesList() {
    return ListView.separated(
        itemCount: 25,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context, index) {
          if (_rssFeed != null && index < _rssFeed.items.length) {
            return ListTile(
              title: Text(_rssFeed.items[index].title),
              subtitle: Text(formatDate(_rssFeed.items[index].pubDate)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadArticle(_rssFeed.items[index]),
                  ),
                );
              },
            );
          }
          return null;
        });
  }

  final DateFormat rssDateFormat = DateFormat('EEE, dd MMM yyyy hh:mm');
  final DateFormat todayDateFormat = DateFormat('hh:mm');
  final DateFormat pastDateFormat = DateFormat('dd MMM hh:mm');

  String formatDate(String date) {
    final DateTime originalDate = rssDateFormat.parseUTC(date).toLocal();
    final DateTime now = DateTime.now();
    final DateTime lastMidnight = new DateTime(now.year, now.month, now.day);
    return lastMidnight.isBefore(originalDate)
        ? todayDateFormat.format(originalDate)
        : pastDateFormat.format(originalDate);
  }
}

class ReadArticle extends StatelessWidget {
  final RssItem feed;
  ReadArticle(this.feed);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feed.source.value),
      ),
      body: Column(
        children: <Widget>[RSSTitle(feed: feed), ArticleText(feed: feed)],
      ),
    );
  }
}

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
      String article = await Article(widget.feed.link).getData();
      setState(() {
        this.articleText = article.length > 0 ? article : 'vuoto';
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

class RSSTitle extends StatelessWidget {
  const RSSTitle({
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
