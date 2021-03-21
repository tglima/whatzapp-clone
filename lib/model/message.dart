class Message {
  String idUser;
  String text;
  String urlImage;
  //Define o tipo da mensagem, que pode ser "texto" ou "imagem"
  String typeMessage;
  String date;
  Message();

  Map<String, dynamic> toMap() {
    return {
      "idUser": this.idUser,
      "text": this.text,
      "urlImage": this.urlImage,
      "typeMessage": this.typeMessage,
      "date": this.date
    };
  }
}
