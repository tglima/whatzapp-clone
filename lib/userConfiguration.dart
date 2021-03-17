import 'dart:io';

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
    switch (pFromCamera) {
      case true:
        selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case false:
        selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

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
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _idUserLogged = user.uid;
  }

  _getUrlImage(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    setState(() {
      _urlImageFromFirebase = url;
    });
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
              _uploadingImage ? CircularProgressIndicator() : Container(),
              CircleAvatar(
                  radius: 100,
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
                    //_validateFields();
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
