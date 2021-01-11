
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../rest_api.dart';
import 'shared.dart';

//AddCategoryAlertDialog
class AddSupplierAlertDialog extends StatefulWidget {
  @override
  _AddSupplierAlertDialogState createState() => _AddSupplierAlertDialogState();
}
class _AddSupplierAlertDialogState extends State<AddSupplierAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  String error = "";
  Map<String, dynamic> AddSupplierData= {
    'Name': null,
    'Email': null,
    'PhoneNumber': null,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Add a new Supplier!", style: TextStyle(color: Colors.teal, fontSize: 35.0,),),
                  SizedBox(height: 20.0),
                  //Name
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Supplier's Name",
                      icon: Icon(Icons.drive_file_rename_outline),
                    ),
                    onChanged: (val){
                      setState(() => AddSupplierData['Name'] = val);
                    },
                    validator: (val) => (val.isEmpty)?"Please fill in the Supplier Name":null,
                  ),
                  SizedBox(height: 20.0),
                  //Email
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Supplier's Email",
                      icon: Icon(Icons.email_outlined),
                    ),
                    onChanged: (val){
                      setState(() => AddSupplierData['Email'] = val);
                    },
                    validator: (val) => (val.isEmpty)?"Please fill in the Supplier Email":null,
                  ),
                  SizedBox(height: 20.0),
                  //Phone Number
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Phone Number (11 digits)",
                      icon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() => AddSupplierData['PhoneNumber'] = val);
                    },
                    validator: (val) {
                      if (!isNumeric(val)) {
                        return "Phone Number must be a number";
                      }
                      else if (val.length != 11) {
                        return "Phone Number must be 11 digits";
                      }
                      else {
                        return null;
                      }
                    }
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.teal,
                            child: Text("Add", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                            onPressed: () async {
                              print(AddSupplierData);
                              if(_formKey.currentState.validate()){
                                //if the form from the client side is valid
                                print("All Valid at the client side:)");
                                print(AddSupplierData);
                                //Server Validation Side
                                dynamic state = await ApiService.addSupplier(AddSupplierData);
                                if(state == null) { print("in null");setState(() => error = "Another Supplier with the same credentials exists!"); }
                                else {
                                  print("in not null");
                                setState(() => error = "");
                                Navigator.pop(context);
                                }
                              }
                            }
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      Expanded(
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.teal,
                            child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                            onPressed: () async {
                              setState(() {
                                error = "";
                              });
                              Navigator.pop(context);
                            }
                        ),
                      )
                    ],
                  ),
                  Text(error, style: TextStyle(color: Colors.red,fontSize: error.isEmpty ? 0.0 : 14.0),),
                  SizedBox(height: 100.0,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class SalesManView_Supplier extends StatefulWidget {
  @override
  _SalesManView_SupplierState createState() => _SalesManView_SupplierState();
}
class _SalesManView_SupplierState extends State<SalesManView_Supplier> {

  SalesManView_SupplierCard(SupplierData){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
              decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text('${SupplierData['Id']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.teal[400]),),
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${SupplierData['Name']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
                Text("${SupplierData['Email']}",  style: TextStyle(color: Colors.white, fontSize: 20.0)),
                SizedBox(height: 5.0,),
                Text("${SupplierData['PhoneNumber']}",  style: TextStyle(color: Colors.white, fontSize: 20.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("All Suppliers", style: TextStyle(color: Colors.white, fontSize: 25.0),),
          actions: [FlatButton(onPressed: null, child: Icon(Icons.person,color: Colors.white,))]
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: ApiService.getSuppliers(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("No Suppliers Yet!", style: TextStyle(fontSize: 30.0, color: Colors.teal),),
                  ),
                );
              }
              else{
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return SalesManView_SupplierCard(snapshot.data[index]);
                    });
              }
            },
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        elevation: 5.0,
        onPressed: () async {
          //An Alert Dialog
          return showDialog(
              context: context,
              builder: (BuildContext context){
                return AddSupplierAlertDialog();
              }
          ).then((value) {setState(() {});});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
