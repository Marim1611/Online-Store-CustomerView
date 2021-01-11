import 'package:flutter/material.dart';
import 'product.dart';
import 'product_details.dart';
import '../rest_api.dart';
import 'addcartClass.dart';
import 'home.dart';
import 'profile.dart';
import 'categories.dart';

/// Order we need map has price and qty of each product in the cart
class TotalPayement {
  final int thePrice, theQuantity,discount;

  TotalPayement({
    this.thePrice,
    this.theQuantity,
    this.discount

  });

  factory TotalPayement.fromJson(Map<String, dynamic>json){
    return TotalPayement(
      thePrice: json['Price'],
      theQuantity: json['Quantity'],
      discount:json['Discount'],
    );
  }
}


class UseProm extends StatefulWidget {
  final int  CUSID;

  UseProm  (this.CUSID,{Key key}):super(key: key);
  @override
  _UsePromState createState() => _UsePromState();
}

class _UsePromState extends State<UseProm> {

  final myController = TextEditingController();
  /// make sure the order
  CreatAlertDialog (BuildContext context , int money )
  {
    return showDialog( context: context, builder: (context){
      return AlertDialog(
        title: Text("Total Payment of this order is $money EGP ,Do you really want to make this order?!"),
        actions: <Widget>[
          /// yes I want the order
          MaterialButton(
              color: Colors.teal,
              elevation:5,
              child: Text ("Yes" , style: TextStyle(
                  color: Colors.white,
                  fontSize: 13
              ),),
              onPressed: () async{

                dynamic order_make= await MakeOrder(widget.CUSID, money);
                dynamic clear_cart= await ClearCart(widget.CUSID);
                Navigator.of(context).pop();
              }),
          /// No cancel the order
          MaterialButton(
              color: Colors.teal,
              elevation:5,
              child: Text ("No" , style: TextStyle(
                  color: Colors.white,
                  fontSize: 13
              ),),
              onPressed: (){
                Navigator.of(context).pop();

              })
        ],

      );
    }
    );
  }
  /// No orders
  CreatAlertDialog2 (BuildContext context )
  {
    return showDialog( context: context, builder: (context){
      return AlertDialog(
        title: Text("No products to order in the cart :)"),
        actions: <Widget>[
          MaterialButton(
              color: Colors.teal,
              elevation:5,
              child: Text ("ok" , style: TextStyle(
                  color: Colors.white,
                  fontSize: 13
              ),),
              onPressed: (){
                Navigator.of(context).pop();
              })
        ],
      );
    }
    );
  }
  CreatAlertDialog3 (BuildContext context )
  {
    return showDialog( context: context, builder: (context){
      return AlertDialog(
        title: Text("invalid PromoCode"),
        actions: <Widget>[
          MaterialButton(
              color: Colors.teal,
              elevation:5,
              child: Text ("OK" , style: TextStyle(
                  color: Colors.white,
                  fontSize: 13
              ),),
              onPressed: (){
                Navigator.of(context).pop();
              })
        ],

      );
    }
    );
  }

  int promocode_discount = 0;
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
            appBar: AppBar
              (backgroundColor: Colors.teal,
              elevation: 0,
              title: Text("Submit Order "),
              centerTitle: true,
            ),
            body:  Container(
                decoration: BoxDecoration(
                  gradient:
                  LinearGradient(
                      colors: <Color>[
                        Colors.teal[400],
                        Colors.teal[300],
                        Colors.teal[700],
                        Colors.teal[400],
                        Colors.teal[700],
                        Colors.teal[300],
                        Colors.teal[400],
                      ]

                  ),

                ),
                height:600,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: myController,
                                  decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(7.0),)),
                                    hintText: 'Write a promo code.. ',
                                    prefixIcon: const Icon(Icons.attach_money_outlined,),
                                  ),
                                ),
                              ),

                              FlatButton(
                                onPressed: () async {

                                  dynamic discount= await CheckPromocode( myController.text);
                                  if ( discount == null )
                                    CreatAlertDialog3(context);
                                  else
                                    {

                                      promocode_discount= discount;
                                      dynamic use= await usepromocode(  widget.CUSID,myController.text);
                                    //  usepromocode(int CustomerID , String code)
                                    }


                                },
                                color: Colors.lightGreen,
                                padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.money_off, color: Colors.white,size: 25,),
                                    SizedBox(width: 2,),
                                    Text("Use Promocode ?" ,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15
                                      ),),
                                  ],
                                ),
                              ),
                            ]
                        ),
                        SizedBox(height: 4,),

                        SizedBox(height: 10,),
                        FlatButton(
                          onPressed: () async {
                            List<TotalPayement> totalprice= await GetTotalPayment(widget.CUSID);
                            int total_payment= 0;
                            for ( int i=0; i < totalprice.length; i++)
                            {
                              /// if use promocode don't apply discount
                              if( promocode_discount != 0)
                              {
                                print( totalprice[i].thePrice);
                                print( totalprice[i].discount);
                                print( totalprice[i].theQuantity);
                                total_payment+= totalprice[i].theQuantity * ( totalprice[i].thePrice -( totalprice[i].thePrice*(promocode_discount/100)).floor() );
                                print(total_payment);

                              }
                              else if ( totalprice[i].discount > 0)
                              {
                                print( totalprice[i].thePrice);
                                print( totalprice[i].discount);
                                print( totalprice[i].theQuantity);
                                total_payment+= totalprice[i].theQuantity * ( totalprice[i].thePrice -( totalprice[i].thePrice*(totalprice[i].discount/100)).floor() );
                                print(total_payment);
                              }
                              else
                                total_payment+= totalprice[i].theQuantity * totalprice[i].thePrice;
                            }
                            print(total_payment);
                            if (total_payment != 0)
                              CreatAlertDialog(context, total_payment);
                            if( total_payment == 0)
                              CreatAlertDialog2(context);

                          },
                          color: Colors.lightGreen,
                          padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.monetization_on, color: Colors.white,size: 25,),
                              SizedBox(width: 2,),
                              Text("Submit order" ,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),),
                            ],
                          ),
                        ),

                      ]),
                )));

  }
}
