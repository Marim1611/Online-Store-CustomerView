import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Promocode.dart';
import 'SalesMan_Category.dart';
import 'SalesMan_LimitedProducts.dart';
import 'SalesMan_Supplier.dart';
import '../rest_api.dart';
import 'shared.dart';

//AddPromocodeAlertDialog
class AddDiscountAlertDialog extends StatefulWidget {
  final int ProductID;
  const AddDiscountAlertDialog ({ Key key, this.ProductID }): super(key: key);
  @override
  _AddDiscountAlertDialogState createState() => _AddDiscountAlertDialogState();
}
class _AddDiscountAlertDialogState extends State<AddDiscountAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  String error = "";
  Map<String, dynamic> AddDiscountData= {
    'Discount': null,
    'EndTimeOffer': convert_DateTime_To_String(DateTime.now().add(Duration(days: 7, hours: 0, minutes: 0))),
  };
  @override
  void initState() {
    // TODO: implement initState
    AddDiscountData.addAll({'ID':widget.ProductID.toString()});
  }
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
                  Text("Add Discount!", style: TextStyle(color: Colors.teal, fontSize: 35.0,),),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter the discount%",
                      icon: Icon(Icons.money_off_csred_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() => AddDiscountData['Discount'] = val.toString());
                    },
                    validator: (val) {
                      if(!isNumeric(val)){return "Please enter a numeric value";}
                      else if(num.parse(val)<=0){return "Discount must be greater than 0";}
                      else if(num.parse(val)>=100){return "Discount must be smaller than 100";}
                      else {return null;}
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.teal,
                      child: Text("Pick the EndTime ", style: TextStyle(color: Colors.white, fontSize: 18.0),),
                      onPressed: () async {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(AddDiscountData['EndTimeOffer']),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2023),
                        ).then((date){
                          setState(() {
                            if (date != null ){
                              AddDiscountData['EndTimeOffer'] = convert_DateTime_To_String(date);
                            }
                          });
                        });
                      }),
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
                              print(AddDiscountData);
                              if(_formKey.currentState.validate()){
                                //if the form from the client side is valid
                                print("All Valid at the client side:)");
                                //go and check if this credentials is valid from the server (DB) side
                                //i.e check if the promocode exists or not
                                //i.e if doesn't exist, then it's added successfully
                                print(AddDiscountData);
                                //Server Validation Side
                                dynamic done = await ApiService.addDiscount(AddDiscountData);
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

class RequestNewProduct extends StatefulWidget {
  final int userIDWhoRequested;
  const RequestNewProduct ({ Key key, this.userIDWhoRequested }): super(key: key);
  @override
  _RequestNewProductState createState() => _RequestNewProductState();
}
class _RequestNewProductState extends State<RequestNewProduct> {
  final _formKey = GlobalKey<FormState>();
  Map<String,dynamic> RequestNewProductData = {
  'CategoryID' : null,
  'SupplierID' : null,
  'Name' : null,
  'Price' : null,
  'Quantity' : null,
  'ExpiryDate' : null,
  'ProductImage' : null,
  'Description' : null,
  'Discount' : null,
  'EndTimeOffer': null
  };
  List<dynamic> AllSuppliers = [];
  List<dynamic> AllCategories = [];

  bool _hasExpirationDate = false;
  bool _hasInitialDiscount = false;
  String error = "";

  @override
  void initState() {
    // TODO: implement initState
    RequestNewProductData.addAll({'userIDWhoRequested':widget.userIDWhoRequested.toString()});
    ApiService.getSuppliers().then((value) {
    setState(() {
      AllSuppliers = value;
    });
    });
    ApiService.getCategories().then((value) {
      setState(() {
        AllCategories = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Request a new product", style: TextStyle(color: Colors.white, fontSize: 25.0), ),
          leading: FlatButton(onPressed: () => Navigator.pop(context), child: Icon(Icons.arrow_back,color: Colors.white,))
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              children: [
                //Name
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Product Name",
                    icon: Icon(Icons.shopping_cart),
                  ),
                  onChanged: (val){
                    setState(() => RequestNewProductData['Name'] = val.toString());
                  },
                  validator: (val) {
                    if(val.isEmpty){return "Please fill in the product's Name";}
                    return null;
                  },
                ),
                SizedBox(height: 20.0,),
                //Category
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Category',
                      icon: Icon(Icons.category)
                    ),
                    items: AllCategories.map((category) {
                      return DropdownMenuItem(
                          value: category['Id'],
                          child: Text("${category['Name']}"));
                    }).toList(),
                    onChanged: (val){
                      setState(() {
                        RequestNewProductData['CategoryID'] = val.toString();
                      });
                    },
                    validator: (val) => (val==null) ? "Please Choose the Product's Category" : null,
                ),
                SizedBox(height: 20.0,),
                //Price
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Price",
                    icon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val){
                    setState(() => RequestNewProductData['Price'] = val.toString());
                  },
                  validator: (val) {
                    return (val.isEmpty) ? "Please fill in the Product's Price" :
                    (!isNumeric(val)) ? "Please fill in a numeric value" :
                    (num.parse(val)<=0) ? "Price must be greater than 0" :
                    null;
                  }
                ),
                SizedBox(height: 20.0,),
                //Image Path
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Product Image's Path",
                    icon: Icon(Icons.image_outlined),
                  ),
                  onChanged: (val){
                    setState(() => RequestNewProductData['ProductImage'] = val.toString());
                  },
                  validator: (val) {
                    if(val.isEmpty){return "Please fill in the Product's Image Path";}
                    return null;
                  },
                ),
                SizedBox(height: 20.0,),
                //Product Description
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Product Description, if exists",
                    icon: Icon(Icons.description_outlined),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (val){
                    setState(() {
                      //if the user enters a description then deleted it, then I want a value of null not "" to be stored
                      if(val.isEmpty) { RequestNewProductData['Description'] = null; }
                      else { RequestNewProductData['Description'] = val.toString(); }
                    } );
                  },
                ),
                SizedBox(height: 20.0,),
                //Suppliers' Names
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      hintText: 'Supplier',
                      icon: Icon(Icons.person)
                  ),
                  items: AllSuppliers.map((supplier) {
                    return DropdownMenuItem(
                        value: supplier['Id'],
                        child: Text("${supplier['Name']}"));
                  }).toList(),
                  onChanged: (val){
                    setState(() {
                      RequestNewProductData['SupplierID'] = val.toString();
                    });
                  },
                  validator: (val) => (val==null) ? "Please Choose the Product's Supplier" : null,
                ),
                SizedBox(height: 20.0,),
                //Quantity
                TextFormField(
                    decoration: InputDecoration(
                      hintText: "Quantity to request",
                      icon: Icon(Icons.shopping_cart),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() => RequestNewProductData['Quantity'] = val.toString());
                    },
                    validator: (val) {
                      return (val.isEmpty) ? "Please fill in the Product's Quantity" :
                      (!isNumeric(val)) ? "Please fill in a numeric value" :
                      (num.parse(val)<=0) ? "Quantity must be greater than 0" :
                      (num.parse(val)>1000) ? "Quantity must be less than 1000" :
                      null;
                    }
                ),
                SizedBox(height: 40.0,),

                Text('Optional Section', style: TextStyle(fontSize: 20.0,color: Colors.teal, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0,),

                CheckboxListTile(
                  title: Text('Does the product have an expiration date?'),
                  value: _hasExpirationDate,
                  onChanged: (value) {
                    setState(() {
                      _hasExpirationDate = !_hasExpirationDate;
                      if(!_hasExpirationDate){RequestNewProductData['ExpiryDate']=null;}
                      else{RequestNewProductData['ExpiryDate']=convert_DateTime_To_String(DateTime.now());}
                    });
                  },
                ),
                SizedBox(height: 10.0,),
                (_hasExpirationDate)? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.teal,
                    child: Text("Pick the Product's ExpiryDate", style: TextStyle(color: Colors.white, fontSize: 18.0),),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(RequestNewProductData['ExpiryDate']),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2023),
                      ).then((date){
                        setState(() {
                          if(date != null){
                            RequestNewProductData['ExpiryDate'] = convert_DateTime_To_String(date);
                          }
                        });
                      });
                    }): SizedBox(height: 0.0,),
                (_hasExpirationDate)? SizedBox(height: 20.0,): SizedBox(height: 0.0,),

                CheckboxListTile(
                  title: Text('Want to add an initial Discount?'),
                  value: _hasInitialDiscount,
                  onChanged: (value) {
                    setState(() {
                      _hasInitialDiscount = !_hasInitialDiscount;
                      if(!_hasInitialDiscount){
                        RequestNewProductData['Discount']=null;
                        RequestNewProductData['EndTimeOffer']=null;
                      }else{
                        RequestNewProductData['EndTimeOffer']=convert_DateTime_To_String(DateTime.now());
                      }
                    });
                  },
                ),
                SizedBox(height: 10.0,),
                (_hasInitialDiscount)? TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter the discount%",
                    icon: Icon(Icons.money_off_csred_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val){
                      setState(() => RequestNewProductData['Discount'] = val);
                      print("Here is Here ${RequestNewProductData['Discount']}");
                  },
                  validator: (val) {
                    if(!isNumeric(val)){return "Please enter a numeric value";}
                    else if(num.parse(val)<=0){return "Discount must be greater than 0";}
                    else if(num.parse(val)>=100){return "Discount must be smaller than 100";}
                    else {return null;}
                  },
                ) : SizedBox(height: 0.0,),
                (_hasInitialDiscount)? SizedBox(height: 20.0,): SizedBox(height: 0.0,),
                (_hasInitialDiscount)? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.teal,
                    child: Text("Pick the Discount's End-Time", style: TextStyle(color: Colors.white, fontSize: 18.0),),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(RequestNewProductData['EndTimeOffer']),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2023),
                      ).then((date){
                        setState(() {
                          if(date != null){
                            RequestNewProductData['EndTimeOffer'] = convert_DateTime_To_String(date);
                          }
                        });
                      });
                    }): SizedBox(height: 0.0,),
                (_hasInitialDiscount)? SizedBox(height: 20.0,): SizedBox(height: 0.0,),

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
                            print(RequestNewProductData);
                            if(_formKey.currentState.validate()){
                              //if the form from the client side is valid
                              print("All Valid at the client side:)");
                              print(RequestNewProductData);
                              //Server Validation Side
                              dynamic done = await ApiService.addProduct(RequestNewProductData);
                              print(RequestNewProductData);
                              setState(() => error = "");
                              Navigator.pop(context);
                            }
                          }
                      ),
                    ),
                    SizedBox(width: 20.0,),
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
    );
  }
}


class SalesManView_Product extends StatefulWidget {
  final Map<String,dynamic> UserData;
  const SalesManView_Product ({ Key key, this.UserData }): super(key: key);
  @override
  _SalesManView_ProductState createState() => _SalesManView_ProductState();
}
class _SalesManView_ProductState extends State<SalesManView_Product> {

  HasNoDiscount_Container(ProductData){
    Map<String,dynamic> AddDiscountData={
      'ID':ProductData['ID'],
      'Discount':null,
      'EndTimeOffer':null,
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${ProductData['Price']}\$", style: TextStyle(color: Colors.white, fontSize: 25.0),),
        SizedBox(height: 10.0,),
        RaisedButton(
          padding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white70,
          elevation: 5.0,
          child: Text("Add Discount", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),),
          onPressed: () async{
            await showDialog(
                context: context,
                builder: (BuildContext context){
                  return AddDiscountAlertDialog(ProductID: AddDiscountData['ID'],);
                }
            ).then((value) {
              setState(() {});
            });
          },
        )
      ],
    );
  }
  HasDiscount_Container(ProductData){    int oldPrice = ProductData['Price'];
    int newPrice = (oldPrice-(oldPrice*ProductData['Discount']/100)).floor();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${ProductData['Price']}\$", style: TextStyle(color: Colors.white, decoration: TextDecoration.lineThrough, fontSize: 20.0),),
        SizedBox(height: 10.0),
        Text("${newPrice}\$",style: TextStyle(color: Colors.white, fontSize: 20.0)),
        SizedBox(height: 10.0),
        Text("till ${ProductData['EndTimeOffer']}", style: TextStyle(color: Colors.white, fontSize: 15.0)),
      ],
    );
  }
  SalesManView_ProductCard(ProductData){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${ProductData['Name']}", style: TextStyle(color: Colors.teal[300], fontSize: 30.0),),
                Text("ID: ${ProductData['ID']}",  style: TextStyle(color: Colors.white, fontSize: 20.0)),
                Text("Quantity: ${ProductData['Quantity']}",  style: TextStyle(color: Colors.white, fontSize: 20.0)),
                SizedBox(height: 10.0,),
                (ProductData['ExpiryDate']!=null)?Text("ExpiryDate: ${ProductData['ExpiryDate']}",  style: TextStyle(color: Colors.white, fontSize: 15.0)):SizedBox(height: 10.0,)
              ],
            ),
          ),
          VerticalDivider(),
          (ProductData['Discount']==0)?HasNoDiscount_Container(ProductData):HasDiscount_Container(ProductData),
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("All Products", style: TextStyle(color: Colors.white, fontSize: 25.0),),
          actions: [FlatButton(onPressed: null, child: Icon(Icons.shopping_bag_outlined,color: Colors.white,))]
      ),
      drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
                gradient:  LinearGradient(
                  begin: Alignment.bottomCenter,
                  colors: [
                    Colors.teal[700],
                    Colors.teal[400],
                    Colors.teal[300],
                    Colors.teal[700],
                    Colors.teal[400],
                    Colors.teal[700],
                    Colors.teal[300],
                    Colors.teal[400],
                    Colors.teal[700],

                  ],)),
            child: ListView(
                children: [

                  ListTiles('Products', Icons.shopping_bag_outlined, (){}),
                  ListTiles('Limited Products', Icons.request_page_outlined, (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesManView_LimitedProducts(UserData: widget.UserData,))).then((value) {setState(() {});});}), // data of all products and their ratings
                  ListTiles('Categories', Icons.category, (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesManView_Category()));}),
                  ListTiles('Suppliers', Icons.assignment_ind_rounded, (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesManView_Supplier()));}) ,
                  ListTiles('Promocodes', Icons.local_offer_outlined, (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PromocodePage()));}), // go to the sign_in page

                  SizedBox(height: 50,),

                  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: IconButton(icon: Icon(Icons.close_rounded, ), onPressed: () {Navigator.pop(context);},)
                  )


                ]),
          ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: ApiService.getProducts_SalesManView(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("No Products Yet!", style: TextStyle(fontSize: 30.0, color: Colors.teal),),
                  ),
                );
              }
              else{
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return SalesManView_ProductCard(snapshot.data[index]);
                    });
              }
            },
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RequestNewProduct(userIDWhoRequested: widget.UserData['Id'],))).then((value) {setState(() {});});
              //the .then function is just used to re-build (refresh) the first page (get products) , after adding a new product (returnning from the pagfe that adds)
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

