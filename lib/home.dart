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
  String _emailUser = "";

  Future _getDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLoged = await auth.currentUser();
    setState(() {
      _emailUser = userLoged.email;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataUser();
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[TabTalk(), TabContact()],
      ),
    );
  }
}
