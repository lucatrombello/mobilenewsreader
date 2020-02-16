import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class Article {
  String link;
  Article(this.link);

  Future<String> getData() async {
    http.Response response = await http.get(this.link);
    dom.Document document = parser.parse(response.body);
    return document
        .getElementsByTagName('p')
        .where((article) => article.text.length > 30)
        .map((article) => '<p>${article.text}</p>')
        .join('');
  }
}
