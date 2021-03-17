import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserConfiguration extends StatefulWidget {
  @override
  _UserConfigurationState createState() => _UserConfigurationState();
}

class _UserConfigurationState extends State<UserConfiguration> {
  TextEditingController _controllerName = TextEditingController();
  File _image;
  String _idUserLogged;
  bool _uploadingImage = false;
  String _urlImageFromFirebase;

  Future _getImage(bool pFromCamera) async {
    File selectedImage;
    PickedFile pickedFile;

    switch (pFromCamera) {
      case true:
        pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
        break;
      case false:
        pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
        break;
    }

    selectedImage = File(pickedFile.path);

    setState(() {
      _image = selectedImage;
      if (_image != null) {
        _uploadingImage = true;
        _uploadImageProfile();
      }
    });
  }

  Future _uploadImageProfile() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference folderRoot = storage.ref();
    StorageReference file =
        folderRoot.child("perfil").child(_idUserLogged + ".jpg");
    StorageUploadTask task = file.putFile(_image);

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
      _getUrlImage(snapshot);
    });
  }

  _getDataUser() async {
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _idUserLogged = user.uid;
    DocumentSnapshot snapshot =
        await db.collection("users").document(_idUserLogged).get();

    Map<String, dynamic> data = snapshot.data;

    _controllerName.text = data["name"];

    if (data["urlImage"] != null) {
      setState(() {
        _urlImageFromFirebase = data["urlImage"];
      });
    }
  }

  _getUrlImage(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _updateUrlImage(url);

    setState(() {
      _urlImageFromFirebase = url;
    });
  }

  _updateUrlImage(String url) {
    Firestore db = Firestore.instance;
    db
        .collection("users")
        .document(_idUserLogged)
        .updateData({"urlImage": url});
  }

  _updateNameUser() {
    Firestore db = Firestore.instance;
    db
        .collection("users")
        .document(_idUserLogged)
        .updateData({"name": _controllerName.text});
  }

  @override
  void initState() {
    super.initState();
    _getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações")),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(16),
                  child: _uploadingImage
                      ? CircularProgressIndicator()
                      : Container()),
              CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey,
                  backgroundImage: _urlImageFromFirebase != null
                      ? NetworkImage(_urlImageFromFirebase)
                      : null),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        _getImage(true);
                      },
                      child: Text("Câmera")),
                  FlatButton(
                      onPressed: () {
                        _getImage(false);
                      },
                      child: Text("Galeria"))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _controllerName,
                  autofocus: true,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 10),
                child: RaisedButton(
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    _updateNameUser();
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
