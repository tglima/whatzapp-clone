class Message {
  String idUser;
  String text;
  String urlImage;
  //Define o tipo da mensagem, que pode ser "texto" ou "imagem"
  String typeMessage;

  Message();

  Map<String, dynamic> toMap() {
    return {
      "idUser": this.idUser,
      "text": this.text,
      "urlImage": urlImage,
      "typeMessage": typeMessage
    };
  }
}
