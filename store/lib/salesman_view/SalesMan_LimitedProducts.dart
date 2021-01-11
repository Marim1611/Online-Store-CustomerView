import 'dart:ui';

import 'package:flutter/material.dart';
import '../rest_api.dart';
import 'shared.dart';

//RequestLimitedProductAlertDialog
class RequestLimitedProductAlertDialog extends StatefulWidget {
  final Map<String,dynamic> ProductData;
  final int userIDWhoRequested;
  const RequestLimitedProductAlertDialog ({ Key key, this.ProductData, this.userIDWhoRequested }): super(key: key);
  @override
  _RequestLimitedProductAlertDialogState createState() => _RequestLimitedProductAlertDialogState();
}
class _RequestLimitedProductAlertDialogState extends State<RequestLimitedProductAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  String error = "";
  Map<String, dynamic> RequestData= {
    'requestedQuantity': null,
  };
  @override
  void initState() {
    // TODO: implement initState
    RequestData.addAll({'ID':widget.ProductData['ID'].toString(), 'Quantity':widget.ProductData['Quantity'].toString(), 'userIDWhoRequested':widget.userIDWhoRequested.toString()});
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Requesting From", style: TextStyle(color: Colors.teal, fontSize: 35.0,),),
                  SizedBox(height: 10.0),
                  Text("Supplier Name: ${widget.ProductData['SupplierName']}"),
                  SizedBox(height: 10.0),
                  Text("Supplier's Phone Number: ${widget.ProductData['PhoneNumber']}"),
                  SizedBox(height: 10.0),
                  Text("Supplier's Email: ${widget.ProductData['Email']}"),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter the added quantity",
                      icon: Icon(Icons.money_off_csred_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() => RequestData['requestedQuantity'] = val.toString());
                    },
                    validator: (val) {
                      if(!isNumeric(val)){return "Please enter a numeric value";}
                      else if(num.parse(val)<=0){return "Quantity must be greater than 0";}
                      else if(num.parse(val)>=1000){return "Quantity can not exceed 1000";}
                      else {return null;}
                    },
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
                            child: Text("Request", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                            onPressed: () async {
                              print(RequestData);
                              if(_formKey.currentState.validate()){
                                //if the form from the client side is valid
                                print("All Valid at Request Limited Product :)");
                                print(widget.ProductData);
                                //Server Validation Side
                                dynamic done = await ApiService.requestProduct(RequestData);
                                setState(() => error = "");
                                Navigator.pop(context);
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


class SalesManView_LimitedProducts extends StatefulWidget {
  final Map<String,dynamic> UserData;
  const SalesManView_LimitedProducts ({ Key key, this.UserData }): super(key: key);
  @override
  _SalesManView_LimitedProductsState createState() => _SalesManView_LimitedProductsState();
}

class _SalesManView_LimitedProductsState extends State<SalesManView_LimitedProducts> {

  SalesManView_LimitedProductCard(ProductData){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text("${ProductData['Name']}", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30.0),)),
              SizedBox(width: 10.0,),
              Expanded(child: Text("ID: ${ProductData['ID']}",  textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30.0))),
            ],
          ),
          SizedBox(height: 10.0,),
          Text("Only ${ProductData['Quantity']} left in stock!",  style: TextStyle(color: Colors.red[800], fontSize: 30.0)),
          SizedBox(height: 10.0,),
          RaisedButton(
            padding: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            elevation: 5.0,
            child: Text("Request Now!", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),),
            onPressed: () async{
              await showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return RequestLimitedProductAlertDialog(ProductData: ProductData, userIDWhoRequested: widget.UserData['Id']);
                  }
              ).then((value) {
                setState(() {});
              });
            },
          )
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text("All Limited Products", style: TextStyle(color: Colors.white, fontSize: 25.0),),
            actions: [FlatButton(onPressed: null, child: Icon(Icons.shopping_bag_outlined,color: Colors.white,))]
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: FutureBuilder(
              future: ApiService.getLimitedProducts_SalesManView(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null){
                  return Container(
                    child: Center(
                      child: Text("No Limited Products Yet!", style: TextStyle(fontSize: 30.0, color: Colors.teal),),
                    ),
                  );
                }
                else{
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        return SalesManView_LimitedProductCard(snapshot.data[index]);
                      });
                }
              },
            )
        )
    );
  }
}
