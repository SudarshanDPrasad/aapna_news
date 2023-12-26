import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/network/network_enums.dart';
import 'package:news_app/network/network_helper.dart';
import 'package:news_app/network/network_service.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/login.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import 'package:news_app/static/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'global/global.dart';
import 'models/database.dart';
import 'network/query_param.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "newsUpdate":
        getData();
        break;
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  // RoomDatabase
  if (!kIsWeb) {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final personDao = database.personDao;
  }

  // Work-manager
  await Workmanager().registerPeriodicTask(
    "newsUpdate",
    "newsUpdate",
    frequency: const Duration(minutes: 15),
  );
  String username = sharedPreferences!.getString("username") != null
      ? sharedPreferences!.getString("username").toString()
      : "";
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: username.isNotEmpty ? const HomeScreen() : const LoginScreen()));
}

class TrendingCarousel extends StatefulWidget {
  const TrendingCarousel({super.key});

  @override
  State<TrendingCarousel> createState() => _TrendingCarouselState();
}

class _TrendingCarouselState extends State<TrendingCarousel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Article> articles = snapshot.data as List<Article>;
            return CarouselSlider(
              options: CarouselOptions(
                height: 400,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
              items: articles.map((i) {
                return Card(
                  elevation: 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => NewsDetailScreen(
                                      article: i,
                                      index: 1,
                                    )));
                      },
                      child: Stack(
                        children: [
                          i.urlToImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    i.urlToImage!,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  "images/no_image.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  fit: BoxFit.fill,
                                ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                i.title!,
                                maxLines: 1,
                                style: TextStyle(
                                    color: i.urlToImage != null
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "Acme"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
