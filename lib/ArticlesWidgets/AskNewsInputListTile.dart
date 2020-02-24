import 'package:flutter/material.dart';

class AskNewsInputListTile extends StatelessWidget {
  final Function(MapEntry<String, String> channel) _onChannelSelected;
  final TextEditingController _textFieldController = TextEditingController();

  AskNewsInputListTile(this._onChannelSelected);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text('SEARCH'),
      onTap: () => _displayDialog(context),
    );
  }

  MapEntry<String, String> _getChannel(value) {
    return MapEntry(value,
        'https://news.google.com/rss/search?q=${Uri.encodeComponent(value)}&hl=it');
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Search'),
            content: TextField(
              autofocus: true,
              autocorrect: false,
              controller: _textFieldController,
              decoration: InputDecoration(hintText: ""),
              onSubmitted: (String value) {
                _selectChannel(value);
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  if (_textFieldController.value.text != '') {
                    _selectChannel(_textFieldController.value.text);
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _selectChannel(String value) {
    _onChannelSelected(_getChannel(value));
  }
}
