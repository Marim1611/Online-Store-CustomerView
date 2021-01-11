import 'package:flutter/material.dart';
import 'product.dart';

class MyCategory {
  ///final int ID,
  final String name,imageC ;
  final int ID_C;

  MyCategory({
     this.imageC,
    this.ID_C,
    this.name
  });

  factory  MyCategory.fromJson(Map<String,dynamic>json ){
    return  MyCategory(
      ID_C:  json['Id'],
      name:  json['Name'],
      imageC:  json['CategoryImage'],

    );
  }


}
