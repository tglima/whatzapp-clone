import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatzapp/model/message.dart';
import 'package:whatzapp/model/user.dart';

import 'model/talk.dart';

class Messages extends StatefulWidget {
  final User contact;
  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController _controllerMessage = TextEditingController();
  String _idUserLogged;
  String _idUserRecipient;
  Firestore _db = Firestore.instance;
  bool _uploadingImage = false;

  _getDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _idUserLogged = user.uid;
    _idUserRecipient = widget.contact.idUser;
  }

  _sendMessage() {
    if (_controllerMessage.text.isNotEmpty) {
      Message message = Message();
      message.idUser = _idUserLogged;
      message.text = _controllerMessage.text;
      message.urlImage = "";
      message.typeMessage = "text";
      _saveMessage(_idUserLogged, _idUserRecipient, message);
      _saveMessage(_idUserRecipient, _idUserLogged, message);
      _saveTalk(message);
      _controllerMessage.clear();
    }
  }

  _sendPhoto() async {
    File selectedImage;
    PickedFile pickedFile;
    pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    selectedImage = File(pickedFile.path);
    _uploadingImage = true;

    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference folderRoot = storage.ref();
    StorageReference file = folderRoot
        .child("messagesImage")
        .child(_idUserLogged)
        .child(fileName + ".jpg");
    StorageUploadTask task = file.putFile(selectedImage);

    task.events.listen((StorageTaskEvent storageTaskEvent) {
      if (storageTaskEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (storageTaskEvent.type == StorageTaskEventType.success) {
        _uploadingImage = false;
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _getUrlImageMessage(snapshot);
    });
  }

  _getUrlImageMessage(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    Message message = Message();
    message.idUser = _idUserLogged;
    message.text = "";
    message.urlImage = url;
    message.typeMessage = "image";
    _saveMessage(_idUserLogged, _idUserRecipient, message);
    _saveMessage(_idUserRecipient, _idUserLogged, message);
  }

  _saveMessage(String idSender, String idRecipient, Message message) async {
    await _db
        .collection("messages")
        .document(idSender)
        .collection(idRecipient)
        .add(message.toMap());
  }

  _saveTalk(Message msg) {
    Talk tSender = new Talk();
    tSender.idUserSender = _idUserLogged;
    tSender.idUserRecipient = _idUserRecipient;
    tSender.message = msg.text;
    tSender.name = widget.contact.name;
    tSender.urlImage = widget.contact.urlImage;
    tSender.typeMessage = msg.typeMessage;
    tSender.saveInFirestore();

    Talk tRecipient = new Talk();
    tRecipient.idUserSender = _idUserRecipient;
    tRecipient.idUserRecipient = _idUserLogged;
    tRecipient.message = msg.text;
    tRecipient.name = widget.contact.name;
    tRecipient.urlImage = widget.contact.urlImage;
    tRecipient.typeMessage = msg.typeMessage;
    tRecipient.saveInFirestore();
  }

  @override
  void initState() {
    super.initState();
    _getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    Container inputMessageBox = Container(
        padding: EdgeInsets.all(8),
        child: Row(children: <Widget>[
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(right: 8),
            child: TextField(
              controller: _controllerMessage,
              autofocus: true,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  hintText: "Digite uma mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)),
                  prefixIcon: _uploadingImage
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: _sendPhoto,
                        )),
            ),
          )),
          FloatingActionButton(
            backgroundColor: Color(0xff075e54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: _sendMessage,
          )
        ]));

    StreamBuilder stream = StreamBuilder(
      stream: _db
          .collection("messages")
          .document(_idUserLogged)
          .collection(_idUserRecipient)
          .snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
                child: Column(children: <Widget>[
              Text("Carregando mensagens"),
              CircularProgressIndicator()
            ]));
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              return Expanded(
                  child: Text("Erro ao carregar os dados das mensagens"));
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, index) {
                      List<DocumentSnapshot> listDocuments =
                          querySnapshot.documents.toList();

                      DocumentSnapshot documentSnapshot = listDocuments[index];

                      double widthMsgBox =
                          MediaQuery.of(context).size.width * 0.8;
                      Alignment msgAlingnment = Alignment.centerRight;
                      Color bgMsgColor = Color(0xffd2ffa5);

                      if (_idUserLogged != documentSnapshot["idUser"]) {
                        msgAlingnment = Alignment.centerLeft;
                        bgMsgColor = Colors.white;
                      }

                      return Align(
                        alignment: msgAlingnment,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                              width: widthMsgBox,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: bgMsgColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child:
                                  documentSnapshot.data["typeMessage"] == "text"
                                      ? Text(documentSnapshot.data["text"],
                                          style: TextStyle(fontSize: 14))
                                      : Image.network(
                                          documentSnapshot.data["urlImage"])),
                        ),
                      );
                    }),
              );
            }
            break;
        }
      },
    );
    CircleAvatar imgUserCircle = CircleAvatar(
        maxRadius: 20,
        backgroundColor: Colors.grey,
        backgroundImage: widget.contact.urlImage != null
            ? NetworkImage(widget.contact.urlImage)
            : null);

    return Scaffold(
        appBar: AppBar(
            title: Row(children: <Widget>[
          imgUserCircle,
          Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(widget.contact.name))
        ])),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
          child: SafeArea(
              child: Container(
            padding: EdgeInsets.all(8),
            child: Column(children: <Widget>[stream, inputMessageBox]),
          )),
        ));
  }
}
