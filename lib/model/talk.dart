import 'package:cloud_firestore/cloud_firestore.dart';

class Talk {
  String idUserSender;
  String idUserRecipient;
  String name;
  String message;
  String urlImage;
  String typeMessage;

  Talk();

  Map<String, dynamic> toMap() {
    return {
      "idUserSender": this.idUserSender,
      "idUserRecipient": this.idUserRecipient,
      "name": this.name,
      "message": this.message,
      "urlImage": this.urlImage,
      "typeMessage": this.typeMessage
    };
  }

  saveInFirestore() async {
    Firestore db = Firestore.instance;
    await db
        .collection("talks")
        .document(this.idUserSender)
        .collection("lastTalk")
        .document(this.idUserRecipient)
        .setData(this.toMap());
  }
}
