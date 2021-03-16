import 'package:flutter/material.dart';
import 'package:whatzapp/home.dart';
import 'package:whatzapp/register.dart';
import 'package:whatzapp/userConfiguration.dart';

import 'login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings pRouteSettings) {
    switch (pRouteSettings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => Login());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/register":
        return MaterialPageRoute(builder: (context) => Register());
      case "/home":
        return MaterialPageRoute(builder: (context) => Home());
      case "/config":
        return MaterialPageRoute(builder: (context) => UserConfiguration());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: Text("Tela não encontrada")),
        body: Center(child: Text("Tela não encontrada!")),
      );
    });
  }
}
