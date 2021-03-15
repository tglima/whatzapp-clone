class User {
  String _name;
  String _email;
  String _passcode;

  User();

  String get passcode => _passcode;
  set passcode(String value) {
    _passcode = value;
  }

  String get email => _email;
  set email(String value) {
    _email = value;
  }

  String get name => _name;
  set name(String value) {
    _name = value;
  }
}
