import 'package:flutter/material.dart';
import 'package:whatzapp/model/talk.dart';

class TabTalk extends StatefulWidget {
  @override
  _TabTalkState createState() => _TabTalkState();
}

class _TabTalkState extends State<TabTalk> {
  List<Talk> _talkList = List();

  @override
  void initState() {
    super.initState();

    Talk talk = new Talk();
    talk.name = "Ana Clara";
    talk.message = "Olá tudo bem?";
    talk.urlImage =
        "https://firebasestorage.googleapis.com/v0/b/cuwhatzapp.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=018c8d65-d4a8-4586-9214-906d079560ea";

    _talkList.add(talk);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _talkList.length,
        itemBuilder: (context, index) {
          Talk talk = _talkList[index];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(talk.urlImage),
            ),
            title: Text(talk.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(
              talk.message,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          );
        });
  }
}
