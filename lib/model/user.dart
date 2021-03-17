class User {
  String _name;
  String _email;
  String _urlImage;
  String _passcode;
  User();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": this.name, "email": this.email};
    return map;
  }

  // ignore: unnecessary_getters_setters
  String get passcode => _passcode;
  // ignore: unnecessary_getters_setters
  set passcode(String value) {
    _passcode = value;
  }

  // ignore: unnecessary_getters_setters
  String get email => _email;
  // ignore: unnecessary_getters_setters
  set email(String value) {
    _email = value;
  }

  // ignore: unnecessary_getters_setters
  String get name => _name;
  // ignore: unnecessary_getters_setters
  set name(String value) {
    _name = value;
  }

  // ignore: unnecessary_getters_setters
  String get urlImage => _urlImage;
  // ignore: unnecessary_getters_setters
  set urlImage(String value) {
    _urlImage = value;
  }
}
