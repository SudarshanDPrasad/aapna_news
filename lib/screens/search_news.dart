import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/article.dart';
import '../models/article_model.dart';
import '../models/database.dart';
import '../network/network_enums.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/query_param.dart';
import '../static/static_values.dart';
import 'news_detail_screen.dart';

class SearchNews extends StatefulWidget {
  String? search;

  SearchNews({this.search});

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
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
                        child: snapshot.data!.isEmpty
                            ? const Text("No Data Found")
                            : Stack(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
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
                                                  onPressed: () async {
                                                    try {
                                                      await Share.share(
                                                          articles[index].url!,
                                                          subject:
                                                              'Look what I made!');
                                                    } catch (err) {
                                                      print("Error $err");
                                                    }
                                                  },
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
                                          icon: const Icon(
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

  Future<List<Article?>> getData() async {
    final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        url: StaticValues.search,
        queryParam:
            QP.searchQP(apiKey: StaticValues.apiKey, q: widget.search!));
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
