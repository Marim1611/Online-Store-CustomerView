class showcomment {
  final int Id,cID,pID;
  final String Msg;


  showcomment({
    this.Msg,
    this.cID,
    this.Id,
    this.pID
  });

  factory showcomment.fromJson(Map<String, dynamic>json){
    return showcomment(
      Id: json['Id'],
      Msg: json['Message'],
      cID: json['CustomerId'],
      pID: json['ProductId'],

    );
  }
}