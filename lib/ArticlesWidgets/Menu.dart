import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
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
          ),
          ListTile(
            leading: Icon(Icons.subtitles),
            title: Text('General'),
          ),
          ListTile(
            leading: Icon(Icons.devices_other),
            title: Text('Technology'),
          ),
          ListTile(
            leading: Icon(Icons.pool),
            title: Text('Sport'),
          ),
        ],
      ),
    );
  }
}
