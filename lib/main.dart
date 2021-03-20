import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatzapp/routeGenerator.dart';
import 'login.dart';

final ThemeData themeDefault =
    ThemeData(primaryColor: Color(0xff075E54), accentColor: Color(0xff25D366));

final ThemeData themeIOS =
    ThemeData(primaryColor: Colors.grey[200], accentColor: Color(0xff25D366));

void main() {
  runApp(MaterialApp(
    home: Login(),
    theme: Platform.isIOS ? themeIOS : themeDefault,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
