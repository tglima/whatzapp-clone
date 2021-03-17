import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatzapp/screen/tabContact.dart';
import 'package:whatzapp/screen/tabTalk.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _menuItems = ["Configurações", "Deslogar"];

  _choseMenuItem(String pItemChosed) {
    switch (pItemChosed) {
      case "Configurações":
        Navigator.pushNamed(context, "/config");
        break;
      case "Deslogar":
        _signOutUser();
        break;
    }
  }

  _signOutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatzApp"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              text: "Conversas",
            ),
            Tab(
              text: "Contatos",
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _choseMenuItem,
            itemBuilder: (context) {
              return _menuItems.map((String item) {
                return PopupMenuItem<String>(value: item, child: Text(item));
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[TabTalk(), TabContact()],
      ),
    );
  }
}
