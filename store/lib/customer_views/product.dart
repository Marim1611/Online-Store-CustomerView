import 'package:flutter/material.dart';
class Product {
  final String image, title,description,expire, endOffer;
  final int price, id,qty,discount,freqency,supplierid,categoryid;


  Product({
    this.id,
    this.image,
    this.title,
    this.price,
this.description,
    this.freqency,
    this.qty,
    this.discount,
    this.supplierid,
    this.categoryid,
    this.expire,
    this.endOffer
});

  factory Product.fromJson(Map<String,dynamic>json ){
    return Product(
        id:  json['ID'],
        categoryid:  json['CategoryID'],
        supplierid:  json['SupplierID'],
        title: json['Name'],
        price:  json['Price'],
        qty:  json['Quantity'],
        description:  json['Description'],
        expire:  json['ExpiryDate'],
        image:  json['ProductImage'],
      discount: json['Discount'],
        endOffer: json['EndTimeOffer'],
        freqency: json['Frequency'],
    );
  }
}
