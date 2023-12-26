import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/screens/bookmark_detail_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../global/global.dart';
import '../models/article.dart';
import '../models/article_bookmark.dart';
import '../models/database.dart';
import '../network/network_service.dart';
import '../network/query_param.dart';
import '../static/static_values.dart';
import 'news_detail_screen.dart';

class BookMarkScreen extends StatefulWidget {
  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  String errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("BookMark"),
          ),
        ),
        body: articlesBookmarks.length != 0
            ? ListView.builder(
                itemCount: articlesBookmarks.length,
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
                                  builder: (c) => BookMarkDetailScreen(
                                        article: articlesBookmarks![index],
                                        index: index,
                                      )));
                        },
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                articlesBookmarks[index].urlToImage != ""
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          articlesBookmarks[index].urlToImage!,
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
                                        articlesBookmarks[index].title!,
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
                                                    articlesBookmarks[index]
                                                        .url!,
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
                                          "By - ${articlesBookmarks[index].sourceName!}",
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
                                      removeArticle(
                                          articlesBookmarks[index].id!);
                                    },
                                    icon: const Icon(
                                      Icons.bookmark,
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
                })
            : const Center(
                child: Column(
                  children: [
                    Icon(Icons.hourglass_empty, color: Colors.black),
                    SizedBox(height: 10),
                    Text("No BookMarks")
                  ],
                ),
              ));
  }

  SnackBar getResultSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  removeArticle(int articleId) async {
    // final response = await NetworkService.sendRequest(
    //     requestType: RequestType.delete,
    //     url: StaticValues.apiAddNewArticle,
    //     body: article);
    // print("Response: ${response?.body}");
    // setState(() {
    //   getArticles();
    // });
    final deleteArticle = jsonEncode({
      "id": articleId,
      "username": sharedPreferences!.getString("username")!,
    });
    final response = await NetworkService.sendRequest(
        requestType: RequestType.delete,
        url: StaticValues.apiDeleteArticle,
        body: deleteArticle);
    print("Response ${response?.statusCode}");
    if (response != null) {
      if (response.statusCode == 200) {
        setState(() {
          getArticles();
          articlesBookmarks;
        });
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        ScaffoldMessenger.of(context)
            .showSnackBar(getResultSnackBar("Something went Wrong!"));
      }
    }
  }

  getArticles() async {
    final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        url: StaticValues.apiUserLogin,
        queryParam: QP.searchUser(
          username: sharedPreferences!.getString("username")!,
          password:
              "12345678", // TODO: change and get this from login and save in shared preference and use here
        ));
    if (response != null) {
      var map = json.decode(response.body);
      var filter = map as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (filter['error'] != null) {
          errorMessage = filter['error'];
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(getResultSnackBar(errorMessage));
        } else if (filter['user']['username'] != null) {
          List list = filter['articles'];
          articlesBookmarks.clear();
          list.forEach((element) {
            ArticleBookmark articleBookmark = ArticleBookmark.fromJson(element);
            articlesBookmarks.add(articleBookmark);
            print("Article : $element");
          });
          setState(() {
            build(context);
          });
        }
      }
    }
  }
}
