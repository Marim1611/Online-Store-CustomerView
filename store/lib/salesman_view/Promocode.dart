import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../rest_api.dart';
import 'shared.dart';
import 'dart:async';


//The Class that draws the horizontal dashed line
class DrawDottedhorizontalline extends CustomPainter {
  Paint _paint;
  DrawDottedhorizontalline() {
    _paint = Paint();
    _paint.color = Colors.white; //dots color
    _paint.strokeWidth = 2; //dots thickness
    _paint.strokeCap = StrokeCap.square; //dots corner edges
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = -150; i < 150; i = i + 15) {
      // 15 is space between dots
      if (i % 3 == 0)
        canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

//AddPromocodeAlertDialog
class AddPromocodeAlertDialog extends StatefulWidget {
  @override
  _AddPromocodeAlertDialogState createState() => _AddPromocodeAlertDialogState();
}
class _AddPromocodeAlertDialogState extends State<AddPromocodeAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  String error = "";
  DateTime selectedDateTime = DateTime.now().add(Duration(days: 7, hours: 0, minutes: 0));
  Map<String, dynamic> AddPromoCodeData= {
    'Code': null,
    'Discount': null,
    'EndTime': convert_DateTime_To_String(DateTime.now().add(Duration(days: 7, hours: 0, minutes: 0))),
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
                  Text("Add a new promocode!", style: TextStyle(color: Colors.teal, fontSize: 35.0,),),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Enter the Code",
                        icon: Icon(Icons.local_offer_outlined)
                    ),
                    onChanged: (val){
                      AddPromoCodeData['Code'] = val;
                      // setState(() => AddPromoCodeData['Code'] = val);
                    },
                    validator: (val) => val.isEmpty ? "Please fill in the Code" : null,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter the discount%",
                      icon: Icon(Icons.money_off_csred_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() => AddPromoCodeData['Discount'] = val);
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
                          initialDate: selectedDateTime,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2023),
                        ).then((date){
                          setState(() {
                            selectedDateTime = (date == null )? selectedDateTime : date;
                            AddPromoCodeData['EndTime'] = convert_DateTime_To_String(selectedDateTime);
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
                              print(AddPromoCodeData);
                              if(_formKey.currentState.validate()){
                                //if the form from the client side is valid
                                print("All Valid at the client side:)");
                                //go and check if this credentials is valid from the server (DB) side
                                //i.e check if the promocode exists or not
                                //i.e if doesn't exist, then it's added successfully
                                print(AddPromoCodeData);
                                //Server Validation Side
                                dynamic promocodeData = await ApiService.addPromocode(AddPromoCodeData);
                                print(promocodeData);
                                if(promocodeData == null) { setState(() => error = "This Code already exists!"); }
                                else {
                                  setState(() => error = "");
                                  print(promocodeData);
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

//The Page Itself of the promocode (SalesMan view)
class PromocodePage extends StatefulWidget {
  @override
  _PromocodePageState createState() => _PromocodePageState();
}
class _PromocodePageState extends State<PromocodePage> {

  //The shape of each promocode item
  PromocodeContainer(Map<String, dynamic> PromoCodeData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      //alignment: Alignment.center,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20.0,20.0,20.0,0.0),
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: Column(
        children: [
          CustomPaint(painter: DrawDottedhorizontalline(),),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20.0,),
                    Text("Code is valid until ${PromoCodeData['EndTime']}", style: TextStyle(fontSize: 15.0, color: Colors.white)),
                    SizedBox(height: 5.0,),
                    Text("${PromoCodeData['Discount']}% OFF", style: TextStyle(fontSize: 40.0, color: Colors.teal[300], fontWeight: FontWeight.bold),),
                    SizedBox(height: 5.0,),
                    Text("${PromoCodeData['Code']}", style: TextStyle(fontSize: 15.0, color: Colors.white)),
                  ],
                ),
              ),
              //DeleteButton
              RaisedButton(
                padding: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10)),
                color: Colors.black,
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Icon(Icons.delete,color: Colors.red,size: 20.0),Text("Delete", style: TextStyle(color: Colors.white),)],),
                onPressed: () async{
                  return showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: Text("Are you sure you want to delete the promocode: ${PromoCodeData['Code']}?", style: TextStyle(color: Colors.teal, fontSize: 20.0,),),
                          actions: [
                            RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                color: Colors.teal,
                                child: Text("Delete", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                                onPressed: () async { await setState(() { ApiService.deletePromocode(PromoCodeData['Code']);}); Navigator.pop(context); }),
                            RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                color: Colors.teal,
                                child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                                onPressed: (){ Navigator.pop(context); }),
                          ],
                        );
                      }
                  );
                },
              )
            ],
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
          title: Text("Promocodes", style: TextStyle(color: Colors.white, fontSize: 25.0), ),
          actions: [FlatButton(onPressed: null, child: Icon(Icons.local_offer_outlined,color: Colors.black,))]
      ),
      body: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          width: double.infinity,
          child: FutureBuilder(
            future: ApiService.getPromocodes(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("No Promocode Yet!", style: TextStyle(fontSize: 30.0, color: Colors.teal),),
                  ),
                );
              }
              else{
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return PromocodeContainer(snapshot.data[index]);
                    });
              }
            },
          )
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        onPressed: () async {
          return showDialog(
          context: context,
          builder: (BuildContext context){
            return AddPromocodeAlertDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


