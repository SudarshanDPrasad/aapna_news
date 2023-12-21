import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/source_news.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import 'category_news.dart';

class TvNewsScreen extends StatefulWidget {
  const TvNewsScreen({super.key});

  @override
  State<TvNewsScreen> createState() => _TvNewsScreenState();
}

class _TvNewsScreenState extends State<TvNewsScreen> {
  final List<Map<String, dynamic>> news = [
    {
      "name": "Google News",
      "url":
      "https://upload.wikimedia.org/wikipedia/commons/9/9b/Google_news_logo.png",
      "id": "google-news-in"
    },
    {
      "name": "BBC News",
      "url":
      "https://www.shutterstock.com/image-vector/bbc-news-logo-vector-editorial-600nw-2335465475.jpg",
      "id": "bbc-news"
    },
    {
      "name": "Times of India",
      "url":
      "https://150176352.v2.pressablecdn.com/wp-content/uploads/2015/12/times-of-india-logo.jpg",
      "id": "the-times-of-india"
    },
    {
      "name": "CBC News",
      "url":
      "https://yt3.googleusercontent.com/UDLxCALyHXJN1-ZTawdO39fhMZLrAiPH2EiwbPNffqmGHkU01HVT20oaPCJvt7iSoRchrTTwvA=s900-c-k-c0x00ffffff-no-rj",
      "id": "cbc-news"
    },
    {
      "name": "CNN",
      "url":
      "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/CNN_International_logo.svg/2048px-CNN_International_logo.svg.png",
      "id": "cnn"
    },
    {
      "name": "ESPN",
      "url":
      "https://cdn.shopify.com/s/files/1/0558/6413/1764/files/ESPN_Logo_Design_History_Evolution_0_1024x1024.jpg?v=1694098855",
      "id": "espn"
    },
  ].toList();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Stream Live Tv News")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, left: 15),
              height: 80,
              child: ListView.builder(
                  itemCount: news.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            icon: Image.network(news[index]['url']),
                            iconSize: 70,
                            onPressed: () {
                              _selectedIndex = index;
                              setState(() {
                                _selectedIndex;
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: SourceNews(source: news[_selectedIndex]['id']),
            ),
          ],
        ),
      ),
    );
  }
}