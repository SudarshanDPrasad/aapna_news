import 'package:floor/floor.dart';

import 'package:floor/floor.dart';

@entity
class Person {
  @primaryKey
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String sourceName;

  Person(this.author, this.title, this.description, this.url, this.urlToImage,
      this.publishedAt, this.content,this.sourceName);
}
