import 'dart:convert';

import 'package:news_app/models/article_bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';
import '../models/article_model.dart';
import '../network/network_enums.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/query_param.dart';
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

Future<List<Article?>> getData() async {
  final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      url: StaticValues.apiUrl,
      queryParam: QP.apiQP(
          apiKey: StaticValues.apiKey, country: StaticValues.apiCountry));
  print("respnse ${response?.statusCode}");
  return NetworkHelper.filterResponse(
      callBack: _listOfArticles,
      response: response,
      parameterName: CallBackParameterName.articles,
      onFailureCallBackWithMessage: (errorType, msg) {
        print('Error Type  - $errorType, Message - $msg');
        return null;
      });
}


List<Article> _listOfArticles(json) => (json as List)
    .map((e) => Article.fromJson(e as Map<String, dynamic>))
    .toList();
