import 'package:flutter/material.dart';
import 'package:whatzapp/model/talk.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: talkList.length,
        itemBuilder: (context, index) {
          Talk talk = talkList[index];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(talk.pathImage),
            ),
            title: Text(talk.userContact,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          );
        });
  }
}
