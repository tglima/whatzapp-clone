import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    _getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatzApp"),
      ),
      body: Container(child: Text(_emailUser)),
    );
  }
}
