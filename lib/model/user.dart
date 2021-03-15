class User {
  String _name;
  String _email;
  String _passcode;

  User();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": this.name, "email": this.email};
    return map;
  }

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
