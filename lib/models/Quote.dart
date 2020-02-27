import './Author.dart';

class Quote {
  String id;
  String body;
  Author author;
  bool isFavorite;

  Quote({this.id, this.body, this.author, this.isFavorite = false});

  Quote.fromMap(Map<String, dynamic> map) {
    body = map['body'];
    id = map['id'].toString();
    author = Author(
        firstName: map['author']['first_name'],
        lastName: map['author']['last_name'],
        shortDescription: map['author']['short_description'],
        pictureUrl: null);
    isFavorite = false;
  }
}
