import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../models/article.dart';
import '../models/article_model.dart';
import '../models/database.dart';
import '../network/network_enums.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/query_param.dart';
import '../static/static_values.dart';
import 'news_detail_screen.dart';

class SourceNews extends StatefulWidget {
  String? source;

  SourceNews({this.source});

  @override
  State<SourceNews> createState() => _SourceNewsState();
}

class _SourceNewsState extends State<SourceNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Article> articles = snapshot.data as List<Article>;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => NewsDetailScreen(
                                        article: articles[index],
                                        index: index,
                                      )));
                        },
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                articles[index].urlToImage != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          articles[index].urlToImage!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        "images/no_image.png",
                                        width: 100,
                                        fit: BoxFit.fill,
                                      ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          190,
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        articles[index].title!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Acme"),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.share,
                                              color: Colors.grey,
                                              size: 10,
                                            )),
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          "By - ${articles[index].source!.name!}",
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontFamily: "Acme"),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: IconButton(
                                    onPressed: () {
                                      saveArticle(
                                          articles[index].author!,
                                          articles[index].title!,
                                          articles[index].description != null
                                              ? articles[index].description!
                                              : "",
                                          articles[index].url!,
                                          articles[index].urlToImage != null
                                              ? articles[index].urlToImage!
                                              : "",
                                          articles[index].publishedAt!,
                                          articles[index].content != null
                                              ? articles[index].content!
                                              : "",
                                          articles[index].source!.name != null
                                              ? articles[index].source!.name!
                                              : "");
                                    },
                                    icon: checkArticle(articles[index].title!)
                                        ? const Icon(
                                            Icons.bookmark,
                                            color: Colors.grey,
                                            size: 20,
                                          )
                                        : const Icon(
                                            Icons.bookmark_outline,
                                            color: Colors.grey,
                                            size: 20,
                                          )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  saveArticle(
      String author,
      String title,
      String description,
      String url,
      String urlToImage,
      String pubslishAt,
      String content,
      String sourceName) async {
    final database =
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    final personDao = database.personDao;
    final person = Person(author, title, description, url, urlToImage,
        pubslishAt, content, sourceName);

    await personDao.insertPerson(person);
  }

  bool checkArticle(String title) {
    bool articlePresent = false;
    articlesBookmark.forEach((element) {
      if(element.title == title){
        articlePresent = true;
      }
    });
    return articlePresent;
  }

  Future<List<Article?>> getData() async {
    final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        url: StaticValues.apiUrl,
        queryParam: QP.sourceQP(
          apiKey: StaticValues.apiKey,
          sources: widget.source!,
        ));
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
}
