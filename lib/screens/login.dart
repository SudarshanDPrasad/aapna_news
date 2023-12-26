import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/user_register.dart';
import 'package:news_app/screens/home_screen.dart';

import '../global/global.dart';
import '../models/article_bookmark.dart';
import '../network/network_enums.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/query_param.dart';
import '../static/static_values.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = '';
  String errorMessage = '';
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 100),
            child: Image.asset(
              'images/app_logo.png',
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200,
            ),
          ),
        ),
        TextField(
          controller: userNameController,
          obscureText: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'UserName',
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          obscureText: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  login();
                },
                child: Text("Login")),
            SizedBox(width: 20),
            ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  register();
                },
                child: Text("Register")),
          ],
        )
      ]),
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

  register() async {
    final msg = jsonEncode({
      "username": userNameController.text.trim(),
      "password": passwordController.text.trim()
    });
    final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        url: StaticValues.apiUserRegister,
        body: msg);
    if (response != null) {
      var map = json.decode(response.body);
      var filter = map as Map<String, dynamic>;
      if (response.statusCode == 200) {
        userName = filter['username'];
        sharedPreferences!.setString("username", userName);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        errorMessage = filter['error'];
        ScaffoldMessenger.of(context)
            .showSnackBar(getResultSnackBar(errorMessage));
      }
    }
  }

  login() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      url: StaticValues.apiUserLogin,
      queryParam: QP.searchUser(
          username: userNameController.text.trim(),
          password: passwordController.text.trim()),
    );
    print("Respnse: ${response?.statusCode}");
    if (response != null) {
      var map = json.decode(response.body);
      var filter = map as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (filter['error'] != null) {
          errorMessage = filter['error'];
          ScaffoldMessenger.of(context)
              .showSnackBar(getResultSnackBar(errorMessage));
        } else if (filter['user']['username'] != null) {
          List list = filter['articles'];
          articlesBookmarks.clear();
          list.forEach((element) {
            ArticleBookmark articleBookmark = ArticleBookmark.fromJson(element);
            articlesBookmarks.add(articleBookmark);
          });
          userName = filter['user']['username'];
          ScaffoldMessenger.of(context)
              .showSnackBar(getResultSnackBar("Welcome back $userName"));
          sharedPreferences!.setString("username", userName);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => HomeScreen()));
        }
      }
    }
  }
}
