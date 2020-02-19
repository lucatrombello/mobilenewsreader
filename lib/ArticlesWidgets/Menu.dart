import 'package:flutter/material.dart';
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
      _getMenuHeader(),
    );
    menuItems.addAll(
      _getListChannels(context),
    );

    return menuItems;
  }

  DrawerHeader _getMenuHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        'Channels',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  List<Widget> _getListChannels(BuildContext context) {
    return channels.entries
        .map(
          (MapEntry<String, String> e) => ListTile(
            leading: Icon(Icons.view_headline),
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
