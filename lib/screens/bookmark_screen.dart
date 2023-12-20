import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/screens/bookmark_detail_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../global/global.dart';
import '../models/article.dart';
import '../models/database.dart';
import 'news_detail_screen.dart';

class BookMarkScreen extends StatefulWidget {

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("BookMark"),
        ),
      ),
      body: articlesBookmark.length != 0 ?
      ListView.builder(
          itemCount: articlesBookmark.length,
          itemBuilder: (context,index){
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
                              article: articlesBookmark![index],
                              index: index,
                            )));
                  },
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          articlesBookmark[index].urlToImage != ""
                              ? ClipRRect(
                            borderRadius:
                            BorderRadius.circular(8.0),
                            child: Image.network(
                              articlesBookmark[index].urlToImage,
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
                                  articlesBookmark[index].title,
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
                                          await Share.share(articlesBookmark![index].url, subject: 'Look what I made!');
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
                                    "By - ${articlesBookmark[index].sourceName}",
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
                                removeArticle(articlesBookmark[index].title);
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
          }
      ) : const Center(
        child: Column(
          children: [
            Icon(Icons.hourglass_empty,color: Colors.black),
            SizedBox(height: 10),
            Text("No BookMarks")
          ],
        ),
      )
    );
  }

  removeArticle(String articleTitle) async {
    final database =
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final personDao = database.personDao;
    print("ARTICLE Title $articleTitle");
    await personDao.removeArticle(articleTitle);

    setState(() {
      getArticles();
    });
  }

  getArticles() async {
    final database =
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final personDao = database.personDao;
    articlesBookmark.clear();
    await personDao.findAllPeople().then((value) {
      value.forEach((element) {
        articlesBookmark.add(element);
      });
    });

    setState(() {
      articlesBookmark;
    });
  }
}
