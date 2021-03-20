import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatzapp/model/user.dart';

class TabTalk extends StatefulWidget {
  @override
  _TabTalkState createState() => _TabTalkState();
}

class _TabTalkState extends State<TabTalk> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUserLogged;
  Firestore _db = Firestore.instance;

  _getDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _idUserLogged = user.uid;

    _addListenerTalks();
  }

  _addListenerTalks() {
    final stream = _db
        .collection("talks")
        .document(_idUserLogged)
        .collection("lastTalk")
        .snapshots();

    stream.listen((snapshots) {
      _controller.add(snapshots);
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataUser();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _controller.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Column(children: <Widget>[
                Text("Carregando conversas"),
                CircularProgressIndicator()
              ]));
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar as conversas");
              }

              QuerySnapshot querySnapshot = snapshot.data;

              if (querySnapshot.documents.length == 0) {
                return Center(
                    child: Text(
                  "Você não tem nenhuma mensagem ainda :(",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ));
              }

              return ListView.builder(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> list =
                        querySnapshot.documents.toList();
                    DocumentSnapshot talkItem = list[index];

                    User user = User();
                    user.name = talkItem["name"];
                    user.urlImage = talkItem["urlImage"];
                    user.idUser = talkItem["idUserRecipient"];

                    return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "/messages",
                              arguments: user);
                        },
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        leading: CircleAvatar(
                            maxRadius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: talkItem["urlImage"] != null
                                ? NetworkImage(talkItem["urlImage"])
                                : null),
                        title: Text(talkItem["name"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(
                            talkItem["typeMessage"] == "text"
                                ? talkItem["message"]
                                : "Imagem...",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12)));
                  });
          }
        });
  }
}
