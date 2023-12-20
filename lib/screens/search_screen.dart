import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/search_news.dart';
import 'package:share_plus/share_plus.dart';

import '../models/article_model.dart';
import '../network/network_enums.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/query_param.dart';
import '../static/static_values.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: searchController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                  prefixIcon:
                      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        searchController.text = "";
                        search = false;
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          search;
                        });
                      },
                      icon: Icon(Icons.clear)),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                search = true;
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  search;
                });
              },
              child: Text("Search")),
          search
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SearchNews(search: searchController.text.trim()))
              : Center(
                  child: Text("No Search Data"),
                )
        ],
      ),
    ));
  }
}

// https://newsapi.org/v2/everything?q=viratKholi&apiKey=ab424053c14248b6bbb7da59fa401cfd
