import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatzapp/register.dart';

import 'home.dart';
import 'model/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPasscode = TextEditingController();
  String _messageError = "";

  _validateFields() {
    String email = _controllerEmail.text.toUpperCase();
    String passcode = _controllerPasscode.text;

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

    user.email = email;
    user.passcode = passcode;

    _authUser(user);
  }

  _authUser(user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: user.email, password: user.passcode)
        .then((firebaseUser) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((error) {
      setState(() {
        _messageError =
            "Erro ao autenticar, verifique os campos e e-mail e senha e tente novamente!";
      });
    });
  }

  Future _isUserloged() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userLoged = await auth.currentUser();
    if (userLoged != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  void initState() {
    _isUserloged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "images/logo.png",
                      width: 200,
                      height: 150,
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
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
                      "Entrar",
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
                  child: GestureDetector(
                    child: Text(
                      "Ainda não tem conta? Cadastre-se!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                      child: Text(
                    _messageError,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
