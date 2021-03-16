import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserConfiguration extends StatefulWidget {
  @override
  _UserConfigurationState createState() => _UserConfigurationState();
}

class _UserConfigurationState extends State<UserConfiguration> {
  TextEditingController _controllerName = TextEditingController();
  File _image;

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
    });
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
              //Carregando
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/cuwhatzapp.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=d2823e97-9979-416a-94ce-61eecd464b08"),
              ),
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
