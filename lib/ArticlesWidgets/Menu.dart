import 'package:flutter/material.dart';
import 'package:mobilenewsreader/ArticlesWidgets/AskNewsInputListTile.dart';
import 'package:mobilenewsreader/resources/channels.dart';

class Menu extends StatelessWidget {
  final Function(MapEntry<String, String> channel) _onChannelSelected;

  Menu(this._onChannelSelected);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: getMenuList(context),
      ),
    );
  }

  List<Widget> getMenuList(BuildContext context) {
    List<Widget> menuItems = List<Widget>();
    menuItems.add(
      _getMenuHeader(context),
    );
    menuItems.addAll(
      _getChannelsList(context),
    );
    menuItems.add(AskNewsInputListTile((channel) {
      _onChannelSelected(channel);
      Navigator.pop(context);
    }));

    return menuItems;
  }

  DrawerHeader _getMenuHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Center(
        child: Text(
          'News channels',
          style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).primaryTextTheme.body1.color),
        ),
      ),
    );
  }

  List<Widget> _getChannelsList(BuildContext context) {
    return channels.entries
        .map(
          (MapEntry<String, String> e) => ListTile(
            leading: Icon(Icons.list),
            title: Text(e.key),
            onTap: () {
              _onChannelSelected(e);
              Navigator.pop(context);
            },
          ),
        )
        .toList();
  }
}
