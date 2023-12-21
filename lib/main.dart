

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/network/network_enums.dart';
import 'package:news_app/network/network_helper.dart';
import 'package:news_app/network/network_service.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import 'package:news_app/static/static_values.dart';
import 'models/database.dart';
import 'network/query_param.dart';

Future<void> main() async {
  if(!kIsWeb){

    WidgetsFlutterBinding.ensureInitialized();
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final personDao = database.personDao;
  }
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  aspectRatio: 16/9,
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
                              width: MediaQuery.of(context).size.width *
                                  0.8,
                              height:
                              MediaQuery.of(context).size.height *
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
              }
            ).toList(),
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
}
