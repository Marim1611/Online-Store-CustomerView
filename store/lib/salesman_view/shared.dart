import 'package:flutter/material.dart';
import 'dart:convert';

//This file contains functions that are commonly used by other files

String convert_DateTime_To_String(DateTime date){
  //DateTime yyyy-mm-dd hh:mm:ss
  //FormattedDBDate "yyyy-mm-dd"
  int dayInt = date.day;
  String dayString = (dayInt <10)? "0${dayInt}": "${dayInt}";
  int monthInt = date.month;
  String monthString = (monthInt <10)? "0${monthInt}": "${monthInt}";

  return "${date.year}-${monthString}-${dayString}";
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

//For the Drawer
//I have put it in the shared so that I and Mariam Zain can use it
class ListTiles extends StatelessWidget {
  String text;
  IconData icon;
  Function ontap;

  ListTiles(this.text, this.icon, this.ontap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: ontap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.white),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      text,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      )

                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_right, color: Colors.white),

          ],
        ),
      ),
    );
  }
}
