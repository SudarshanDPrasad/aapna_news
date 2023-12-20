import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/main.dart';
import 'package:news_app/screens/category_news.dart';

import '../models/article_model.dart';
import '../network/network_enums.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/query_param.dart';
import '../static/static_values.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<String> news = [
    "Business",
    "Sports",
    "Entertainment",
    "General",
    "Science",
    "Technology",
    "Health"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Trending News",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Acme"),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Home(),
          ),
          SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(top: 5, left: 15),
            height: 50,
            child: ListView.builder(
                itemCount: news.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 120,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedIndex == index
                                  ? Colors.cyan
                                  : Colors.transparent),
                          onPressed: () {
                            _selectedIndex = index;
                            setState(() {
                              _selectedIndex;
                            });
                          },
                          child: Text(
                            news[index],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: "Signatra"),
                          )),
                    ),
                  );
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CategoryNews(category: news[_selectedIndex]),
          )
        ],
      ),
    ));
  }
}