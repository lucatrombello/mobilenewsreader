import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilenewsreader/ArticleUtils/TimeUtils.dart';
import 'package:mobilenewsreader/ArticlesWidgets/ArticleLink.dart';
import 'package:mobilenewsreader/ArticlesWidgets/Menu.dart';
import 'package:mobilenewsreader/ArticlesWidgets/PubDate.dart';
import 'package:mobilenewsreader/ArticlesWidgets/ReadArticlePage.dart';
import 'package:mobilenewsreader/resources/channels.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webfeed/webfeed.dart';

class ArticlesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 17.0),
          subhead: TextStyle(fontSize: 18.0),
        ),
      ),
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
  DateTime _lastUpdate = DateTime.now();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await update();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

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

  Future update() async {
    http.Response response = await http.get(_channel.value);
    if (response.statusCode == 200) {
      setState(() {
        _rssFeed = RssFeed.parse(response.body);
        _rssFeed.items.sort(TimeUtils().sortRssItemsByPubDate);
        _lastUpdate = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_channel.key),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: PubDate(
              date: _lastUpdate,
            ),
          )
        ],
      ),
      drawer: Menu(setChannel),
      body: _buildSmartRefresher(),
    );
  }

  SmartRefresher _buildSmartRefresher() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: _buildArticlesList(),
    );
  }

  ListView _buildArticlesList() {
    return ListView.separated(
        itemCount: 25,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context, index) {
          if (_rssFeed != null && index < _rssFeed.items.length) {
            var rssItem = _rssFeed.items[index];
            return ListTile(
              title: Text(rssItem.title),
              subtitle: PubDate(
                stringDate: rssItem.pubDate,
              ),
              trailing: ArticleLink(feed: rssItem),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadArticlePage(rssItem),
                  ),
                );
              },
            );
          }
          return null;
        });
  }
}
