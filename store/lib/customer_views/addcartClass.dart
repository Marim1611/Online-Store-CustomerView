import 'package:flutter/material.dart';
import 'product.dart';
import '../rest_api.dart';

class AddToMyCart{

  final int CusID,ProID,Qty;

  AddToMyCart({
    this.CusID,
    this.ProID,
    this.Qty
  });

  factory  AddToMyCart.fromJson(Map<String,dynamic>json ){
    return AddToMyCart(
      ProID:  json['ProductId'],
      CusID:  json['CustomerId'],
      Qty:  json['Quantity'],

    );
  }


}