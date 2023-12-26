import 'dart:convert';

import 'package:news_app/models/article_bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';
import '../network/network_service.dart';
import '../static/static_values.dart';

List<Person> articlesBookmark = [];
List<ArticleBookmark> articlesBookmarks = [];
SharedPreferences? sharedPreferences;

saveArticle(
    String author,
    String title,
    String description,
    String url,
    String urlToImage,
    String pubslishAt,
    String content,
    String sourceName) async {
  // final database =
  //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //
  // final personDao = database.personDao;
  // final person = Person(author, title, description, url, urlToImage,
  //     pubslishAt, content, sourceName);
  //
  // await personDao.insertPerson(person);

  final article = jsonEncode({
    "username": sharedPreferences!.getString("username")!,
    "author": author,
    "title": title.replaceFirst(RegExp("'"),""),
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": pubslishAt,
    "content": content,
    "sourceName": sourceName
  });
  final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      url: StaticValues.apiAddNewArticle,
      body: article);
  print("Response: ${response?.body}");
}

