import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatzapp/model/talk.dart';
import 'package:whatzapp/model/user.dart';

class TabContact extends StatefulWidget {
  @override
  _TabContactState createState() => _TabContactState();
}

class _TabContactState extends State<TabContact> {
  List<Talk> talkList = [
    Talk("Ana Clara", "Olá tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/cuwhatzapp.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=018c8d65-d4a8-4586-9214-906d079560ea"),
    Talk("Pedro Silva", "Me manda o nome daquela serie que falamos!",
        "https://firebasestorage.googleapis.com/v0/b/cuwhatzapp.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=8526b8cd-279e-4e9d-8d89-9d4f4dbfdee9"),
    Talk("Marcela Almeida", "Vamos sair hoje?",
        "https://firebasestorage.googleapis.com/v0/b/cuwhatzapp.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=d2823e97-9979-416a-94ce-61eecd464b08"),
    Talk("José Renato", "Não vai acreditar no que tenho para te contar...",
        "https://firebasestorage.googleapis.com/v0/b/cuwhatzapp.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=c99204b9-5e89-4dc9-9f0c-8aa970b9512b"),
    Talk("Professor", "Conseguiu terminar o curso?",
        "https://firebasestorage.googleapis.com/v0/b/cuwhatzapp.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=9b615a59-671b-46cc-bd27-086b0b184c51")
  ];

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
