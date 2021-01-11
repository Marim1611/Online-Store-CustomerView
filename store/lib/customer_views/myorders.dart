import 'package:flutter/material.dart';
import 'package:customer_views/rest_api.dart';
import '../rest_api.dart';
 import 'OrderDetails.dart';
 import 'cart.dart';
 import 'calss_order.dart';
 import 'delivery_rate.dart';

class MyOrders extends StatefulWidget {
  final int  CUSID;

  MyOrders(this.CUSID, {Key key}):super(key: key);
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('All Orders',
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Cart(widget.CUSID)));
            },
          ),
        ],
      ),
      body:  Container(
          height: 3000,
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
          child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: FutureBuilder<dynamic>(

                  future: GetMyOrders(widget.CUSID) ,
                  builder: (context,snapshot) {
                    if (snapshot.hasData) {

                      List data = snapshot.data;
                      if(data.length==0)
                      {
                        return Center(
                          child: Text(
                            "No Orders yet\n See our Offers and order Now! ",
                            style:TextStyle( fontSize: 40, color: Colors.black, fontWeight:FontWeight.w400,),),
                        );
                      }
                      return   SizedBox(child:Orders_view(data,widget.CUSID),height: 2000,);
                    }
                    else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Text("No Orders Yet");
                  },
                ),
              ),

        ),



    );
  }
}
/// orders  grid
GridView Orders_view(data , int CUSid){
  return  GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing:10,
        crossAxisSpacing: 30,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context,index) =>
      OrderCard ( order: data[index],
            press: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyOrderDetails(
                  order: data[index],CUSTID: CUSid,)
                  ,)), CUSID: CUSid,
      ));
}
/// Order Card
String Is_Deliverd ="";
bool Is_DM_Rated=false;
class OrderCard extends StatefulWidget {
  final OrderM order;
  final Function press;
  final int CUSID;
  const OrderCard({Key key, this.order, this.press,this.CUSID }): super(key:key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  CreatAlertDialog (BuildContext context, String msg )
  {
    return showDialog( context: context, builder: (context){
      return AlertDialog(
        title: Text(msg),
        actions: <Widget>[
          MaterialButton(
              color: Colors.teal,
              elevation:5,
              child: Text ("OK" , style: TextStyle(
                  color: Colors.white,
                  fontSize: 13
              ),),
              onPressed: (){
                   /// if order is deliverd
                if (Is_Deliverd ==  "Order is delivered Hope you like it :)  ")
                  {
                    /// if not  rated before
                    if( !Is_DM_Rated )
                      {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DeliveryRate (widget.CUSID, widget.order.DMid))).then((value) {  Navigator.of(context).pop();} );

                          Is_DM_Rated= true;
                      }

                    /// if already rated before
                    else
                      Navigator.of(context).pop();

                  }
                else
                Navigator.of(context).pop();

              })
        ],

      );
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.press,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.teal[100],
            borderRadius: BorderRadius.circular(18),),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon( Icons.local_shipping, color: Colors.teal,size: 35,),
                            SizedBox(width: 20,),
                            Text("Order ID: ${widget.order.ID}", style:TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            Icon( Icons.monetization_on ,color: Colors.teal,size: 35),
                            SizedBox(width: 20,),
                            Text("Total payment: ${ widget.order.TOTpay}.00 EGP", style:TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.home_outlined ,color: Colors.teal,size: 35),
                              onPressed: () {
                                  if ( widget.order.ISDELV == 0)
                                    Is_Deliverd = "Order will find you soon :) ";
                                  else  if ( widget.order.ISDELV == 1)
                                   {
                                     Is_Deliverd = "Order is delivered Hope you like it :)  ";
                                   }
                                  CreatAlertDialog(context,Is_Deliverd);

                              },
                            ),
                            SizedBox(width: 4,),
                            Text( "Is Delivered ?",
                              style:TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),),
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),),
        )
    );
  }
}