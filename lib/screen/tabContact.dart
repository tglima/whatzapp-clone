import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatzapp/model/user.dart';

class TabContact extends StatefulWidget {
  @override
  _TabContactState createState() => _TabContactState();
}

class _TabContactState extends State<TabContact> {
  // ignore: unused_field
  String _idUserLogged = "";
  String _emailUserLogged = "";

  Future<List<User>> _getContacts() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection("users").getDocuments();
    List<User> userList = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dataUser = item.data;

      if (dataUser["email"].toString().toUpperCase() ==
          _emailUserLogged.toUpperCase()) continue;

      User user = User();
      user.idUser = item.documentID;
      user.email = dataUser["email"];
      user.name = dataUser["name"];
      user.urlImage = dataUser["urlImage"];
      userList.add(user);
    }
    return userList;
  }

  Future _getDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLogged = await auth.currentUser();
    _idUserLogged = userLogged.uid;
    _emailUserLogged = userLogged.email;
  }

  @override
  void initState() {
    _getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
        future: _getContacts(),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Column(
                children: <Widget>[
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ));
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List<User> userList = snapshot.data;
                    User user = userList[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/messages",
                            arguments: user);
                      },
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: user.urlImage != null
                              ? NetworkImage(user.urlImage)
                              : null),
                      title: Text(user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                    );
                  });
              break;
          }
        });
  }
}
