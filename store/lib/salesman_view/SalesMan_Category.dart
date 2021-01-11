
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../rest_api.dart';

//AddCategoryAlertDialog
class AddCategoryAlertDialog extends StatefulWidget {
  @override
  _AddCategoryAlertDialogState createState() => _AddCategoryAlertDialogState();
}
class _AddCategoryAlertDialogState extends State<AddCategoryAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  String error = "";
  Map<String, dynamic> AddCategoryData= {
    'Name': null,
    'CategoryImage': null,
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
                  Text("Add a new Category!", style: TextStyle(color: Colors.teal, fontSize: 35.0,),),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Category Name",
                      icon: Icon(Icons.drive_file_rename_outline),
                    ),
                    onChanged: (val){
                      setState(() => AddCategoryData['Name'] = val);
                    },
                    validator: (val) => (val.isEmpty)?"Please fill in the category name":null,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Category Image Path",
                      icon: Icon(Icons.image_outlined),
                    ),
                    onChanged: (val){
                      setState(() => AddCategoryData['CategoryImage'] = val);
                    },
                    validator: (val) => (val.isEmpty)?"Please fill in the Category \nImage Path":null,
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
                              print(AddCategoryData);
                              if(_formKey.currentState.validate()){
                                //if the form from the client side is valid
                                print("All Valid at the client side:)");
                                print(AddCategoryData);
                                //Server Validation Side
                                dynamic state = await ApiService.addCategory(AddCategoryData);
                                if(state == null) { setState(() => error = "This Category already exists!"); }
                                else {
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


class SalesManView_Category extends StatefulWidget {
  @override
  _SalesManView_CategoryState createState() => _SalesManView_CategoryState();
}
class _SalesManView_CategoryState extends State<SalesManView_Category> {

  SalesManView_CategoryCard(CategoryData){
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
          CircleAvatar(
            backgroundColor: Colors.white ,
              radius: 40.0,
              backgroundImage: NetworkImage(CategoryData['CategoryImage'])
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${CategoryData['Name']}", style: TextStyle(color: Colors.white, fontSize: 30.0),),
                SizedBox(height: 5.0,),
                Text("ID: ${CategoryData['Id']}",  style: TextStyle(color: Colors.white, fontSize: 20.0)),
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
          title: Text("All Categories", style: TextStyle(color: Colors.white, fontSize: 25.0),),
          actions: [FlatButton(onPressed: null, child: Icon(Icons.category,color: Colors.white,))]
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: ApiService.getCategories(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("No Categories Yet!", style: TextStyle(fontSize: 30.0, color: Colors.teal),),
                  ),
                );
              }
              else{
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return SalesManView_CategoryCard(snapshot.data[index]);
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
                  return AddCategoryAlertDialog();
                }
          ).then((value) {setState(() {});});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
