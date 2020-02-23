import 'package:flutter/material.dart';

class AskNewsInputButton extends StatelessWidget {
  final Function(MapEntry<String, String> channel) _onChannelSelected;
  final TextEditingController _textFieldController = TextEditingController();

  AskNewsInputButton(this._onChannelSelected);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.symmetric(horizontal: 28.0),
      icon: Icon(Icons.search),
      onPressed: () => _displayDialog(context),
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
