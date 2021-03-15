import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'model/user.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPasscode = TextEditingController();
  String _messageError = "";

  _validateFields() {
    String name = _controllerName.text.toUpperCase();
    String email = _controllerEmail.text.toUpperCase();
    String passcode = _controllerPasscode.text;

    if (name.length < 5) {
      setState(() {
        _messageError = "Nome precisa ter mais que 4 caracteres";
      });
      return;
    }

    if (!email.contains("@")) {
      setState(() {
        _messageError = "E-mail inválido!";
      });
      return;
    }

    if (passcode.length <= 6) {
      setState(() {
        _messageError = "Senha deve conter mais de 6 caracteres";
      });
      return;
    }

    User user = new User();

    user.name = name;
    user.email = email;
    user.passcode = passcode;

    _registerInFirebase(user);
  }

  _registerInFirebase(User pUser) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: pUser.email, password: pUser.passcode)
        .then((firebaseUser) {
      Firestore db = Firestore.instance;
      db.collection("users").document(firebaseUser.uid).setData(pUser.toMap());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((error) {
      setState(() {
        _messageError =
            "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "images/usuario.png",
                      width: 180,
                      height: 135,
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerName,
                    autofocus: true,
                    keyboardType: TextInputType.text,
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
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerPasscode,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _validateFields();
                    },
                  ),
                ),
                Center(
                    child: Text(
                  _messageError,
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
