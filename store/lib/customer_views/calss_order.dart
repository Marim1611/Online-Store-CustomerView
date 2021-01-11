import 'package:flutter/material.dart';

class OrderM {

  final int cusID,ID,DMid,TOTpay,ISDELV;

  OrderM ({
   this.cusID,
    this.ID,
    this.DMid,
    this.TOTpay,
    this.ISDELV
  });

  factory   OrderM .fromJson(Map<String,dynamic>json ){
    return   OrderM (
        cusID:json['CustomerId'],
      ID:  json['Id'],
      DMid:  json['DeliveryManId'],
        TOTpay:  json['TotalPayment'],
        ISDELV:  json['IsDelivered'],
    );
  }


}