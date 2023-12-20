import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailScreen extends StatefulWidget {
  Article? article;
  int? index;

  NewsDetailScreen({this.article, this.index});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late WebViewController _webViewController;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.article!.title!,
              style: TextStyle(
                  color: Colors.white, fontFamily: "Acme", fontSize: 14)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          )),
      body: Container(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.article!.urlToImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.article!.urlToImage!,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4,
                    fit: BoxFit.fill,
                  ),
                )
                    : Image.asset(
                  "images/no_image.png",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.article!.title!,
                    style: TextStyle(color: Colors.white, fontFamily: "Acme"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.article!.content != null
                        ? widget.article!.content!
                        : "Data Not available ",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontFamily: "Acme"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Published on : ${widget.article!
                        .publishedAt!
                        .split("T")
                        .take(1)
                        .first}",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontFamily: "Acme"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Published by : ${widget.article!.source!.name}",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontFamily: "Acme"),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled :true,
                      context: context,
                      builder: (context){
                        return ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: WebView(
                                initialUrl: widget.article!.url!,
                                zoomEnabled: true,
                                onProgress: (progress) {
                                  setState(() {
                                    _progress = progress / 100;
                                  });
                                },
                                onWebViewCreated: (controller) {
                                  _webViewController = controller;
                                },
                              ),
                            )
                          ],
                        );
                      }
                  );
                },
                child: Text(
                  "Available at ${widget.article!.source!
                      .name} \nTap to know more",
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static void launchUrlNews(String url) async {
    final mapUrl = url;
    try {
      await launch(mapUrl,
          forceSafariVC: true, forceWebView: true, enableJavaScript: true);
    } catch (e) {
      print("Count lauch $e");
    }
  }
}
