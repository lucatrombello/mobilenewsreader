import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';

class ArticleLink extends StatelessWidget {
  final RssItem feed;
  ArticleLink({@required this.feed});

  _launchURL() async {
    String url = feed.link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _launchURL,
      icon: Icon(Icons.link),
    );
  }
}
