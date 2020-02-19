import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilenewsreader/ArticlesWidgets/Menu.dart';
import 'package:mobilenewsreader/ArticlesWidgets/ReadArticlePage.dart';
import 'package:mobilenewsreader/resources/channels.dart';
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';

class ArticlesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mobilenewsreader',
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
  MapEntry<String, String> _channel;

  void setChannel(MapEntry<String, String> channel) {
    setState(() {
      _channel = channel;
      update();
    });
  }

  @override
  void initState() {
    super.initState();
    _channel = channels.entries.first;
    update();
  }

  void update() async {
    http.Response response = await http.get(_channel.value);
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
        title: Text(_channel.key),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.update,
            ),
            onPressed: update,
          )
        ],
      ),
      drawer: Menu(setChannel),
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
                    builder: (context) =>
                        ReadArticlePage(_rssFeed.items[index]),
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
