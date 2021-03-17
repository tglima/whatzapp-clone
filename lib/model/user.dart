class User {
  String idUser;
  String name;
  String email;
  String urlImage;
  String passcode;

  User();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": this.name, "email": this.email};
    return map;
  }
}
