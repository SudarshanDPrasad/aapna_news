import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/bookmark_screen.dart';
import 'package:news_app/screens/main_screen.dart';
import 'package:news_app/screens/search_screen.dart';
import 'package:news_app/screens/tv_news.dart';

import '../global/global.dart';
import '../models/article.dart';
import '../models/article_bookmark.dart';
import '../models/database.dart';
import '../network/network_service.dart';
import '../network/query_param.dart';
import '../static/static_values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Aapna News")),
      ),
      bottomNavigationBar: !kIsWeb
          ? NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              indicatorColor: Colors.amber,
              selectedIndex: _selectedIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.search),
                  icon: Icon(Icons.search_off_rounded),
                  label: 'Search',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.bookmark),
                  icon: Icon(Icons.bookmark_outline),
                  label: 'BookMark',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.live_tv),
                  icon: Icon(Icons.tv_outlined),
                  label: 'Live Tv News',
                ),
              ],
            )
          : NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              indicatorColor: Colors.amber,
              selectedIndex: _selectedIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.search),
                  icon: Icon(Icons.search_off_rounded),
                  label: 'Search',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.live_tv),
                  icon: Icon(Icons.tv_outlined),
                  label: 'Live Tv News',
                ),
              ],
            ),
      body: !kIsWeb
          ? <Widget>[
              /// Home page
              const MainScreen(),

              /// Notifications page
              const SearchScreen(),

              /// BookMark page
              BookMarkScreen(),

              /// Live Tv News page
              TvNewsScreen()
            ][_selectedIndex]
          : <Widget>[
              /// Home page
              const MainScreen(),

              /// Notifications page
              const SearchScreen(),

              /// Live Tv News page
              TvNewsScreen()
            ][_selectedIndex],
    );
  }
}
