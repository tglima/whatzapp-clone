import 'package:flutter/material.dart';
import 'package:whatzapp/model/user.dart';

class Messages extends StatefulWidget {
  User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contact.name)),
      body: Container(),
    );
  }
}
