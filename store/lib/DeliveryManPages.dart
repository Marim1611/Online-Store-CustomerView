// import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'rest_api.dart';
import 'main.dart';


//////////////////////////////////////////////////////////////////This is the Main Page for the Delivery Man////////////////////////////////////////////////////////////////////
class DMHome extends StatefulWidget {
  final String  DMID;

  DMHome(this.DMID,{Key key}):super(key: key);
  @override

  _DMHomeState createState() => _DMHomeState();
}

class _DMHomeState extends State<DMHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Home Page"),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
          child :Container(
            decoration: BoxDecoration(
              gradient:LinearGradient(
                  colors:<Color>[
                    Colors.teal,
                    Colors.tealAccent,
                  ]
              ),
            ),


            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0,horizontal:0.0),
              child: ListView(
                children:<Widget> [
                  CustomListTile(Icons.person,'My Profile',()=>{ }),
                  CustomListTile(Icons.article_outlined,"My Orders",()=>{
                    Navigator.push(context,MaterialPageRoute(builder:(context)=> new MyAssignedOrders(widget.DMID)))}),
                  CustomListTile(Icons.lock, "Log Out",()=>{
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>  WelcomePage() ),(Route<dynamic>route)=>false )
                  })
                ],
              ),
            ),
          )
      ),


      body:FutureBuilder<dynamic>(
        future:GetOrder(),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            if(data.length==0){
              return Center(
                child: Text(
                  "No Orders Yet",
                  style:TextStyle( fontSize: 18, color: Colors.white, fontWeight:FontWeight.w400,),),
              );
            }
            return UnassignedOrdersList(data);
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Text("No Orders Yet");
        },
      ),
      backgroundColor: Colors.teal[300],
    );
  }

  ListView UnassignedOrdersList(data){
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: ( context,index){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            child: Card(
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color:Colors.grey,
              elevation:30,
              margin:EdgeInsets.symmetric(horizontal: 25,vertical:6),
              child: Container(
                child: Column(
                  children:<Widget> [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:30,vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget> [
                          Text(
                            //Customer Name
                            "Customer Name: ${data[index].FirstName} ${ data[index].SecondName}",
                            style:TextStyle(
                              fontSize: 18,
                              color:Colors.white,
                              fontWeight:FontWeight.w800,
                            ),

                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:30,vertical: 5),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Street : ${data[index].StreetName}, ",
                            style:TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight:FontWeight.w400,
                            ),
                          ),
                          Text(
                            " City: ${data[index].City}",
                            style:TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight:FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:30,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          FlatButton(
                            color:Colors.white,
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side:BorderSide(color:Colors.teal),
                            ),
                            onPressed:(){

                              //here it just rebuilds the page once more
                              setState(() {
                                DeliverOrder(widget.DMID,data[index].Id.toString());
                              });
                            },
                            child:Row(
                              children:<Widget> [
                                Text(
                                  "Deliver Order ",
                                  style:TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal,
                                    fontWeight:FontWeight.w400,
                                  ),

                                ),
                                Icon(Icons.delivery_dining),
                              ],
                            ),),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        }
    );
  }

}
//////////////////////////////////////////////////////////////////////////////This is for the drawer /////////////////////////////////////////////////////////////////////////////

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon,this.text,this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom:BorderSide(color: Colors.grey[900])),
        ),
        child: InkWell(
          onTap: onTap,
          child:Container(
            height: 50.0,
            child: Row(
              children:<Widget>[
                Icon(icon,
                  color:Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(text,
                    style: TextStyle(
                      fontSize: 18.0,
                      color:Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////This is for Delivery Man Assigned Orders Page /////////////////////////////////////////////////////////////////

class MyAssignedOrders extends StatefulWidget {
  final String  DMID;

  MyAssignedOrders(this.DMID,{Key key}):super(key: key);
  @override
  _MyAssignedOrdersState createState() => _MyAssignedOrdersState();
}

class _MyAssignedOrdersState extends State<MyAssignedOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("My Orders"),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
          child :Container(
            decoration: BoxDecoration(
              gradient:LinearGradient(
                  colors:<Color>[
                    Colors.teal,
                    Colors.tealAccent,
                  ]
              ),
            ),


            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0,horizontal:0.0),
              child: ListView(
                children:<Widget> [
                  CustomListTile(Icons.person,'My Profile',()=>{ }),
                  CustomListTile(Icons.delivery_dining,'Home Page',()=>{Navigator.pop(context), Navigator.pop(context),  Navigator.pop(context),}),
                  CustomListTile(Icons.lock, "Log Out",()=>{
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>  WelcomePage() ),(Route<dynamic>route)=>false )
                  })
                ],
              ),
            ),
          )
      ),
      body: FutureBuilder<dynamic>(
        future: MyOrders(widget.DMID),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            if(data.length==0){
              return Center(
                child: Text(
                  "You Have No Orders To Deliver Now ..",
                  style:TextStyle( fontSize: 18, color: Colors.white, fontWeight:FontWeight.w400,),),
              );
            }
            return AssignedOrdersList(data);
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Text("No Orders Yet");
        },
      ),
      backgroundColor: Colors.teal[300],
    );
  }
  ListView AssignedOrdersList(data){
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 130,
            child: Card(
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color:Colors.grey,
              elevation:30,
              margin:EdgeInsets.symmetric(horizontal: 10,vertical:6),
              child: Container(
                child: Column(
                  children:<Widget> [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget> [
                          Text(
                            "Customer: ${data[index].FirstName}  ${data[index].SecondName}",
                            style:TextStyle(
                              fontSize: 16,
                              color:Colors.white,
                              fontWeight:FontWeight.w800,
                            ),

                          ),
                          FlatButton(
                            color:Colors.white,
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side:BorderSide(color:Colors.teal),
                            ),
                            onPressed:(){

                              setState(() {
                                MarkOrderDelivered(data[index].Id.toString());
                              });
                            },
                            child:Row(
                              children:<Widget> [
                                Text(
                                  "Delivered  ",
                                  style:TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal,
                                    fontWeight:FontWeight.w400,
                                  ),

                                ),
                                Icon(Icons.assignment_turned_in_sharp),
                              ],
                            ),),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "City: ${data[index].City}",
                            style:TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight:FontWeight.w400,
                            ),
                          ),
                          FlatButton(
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side:BorderSide(color:Colors.teal),
                            ),
                            color:Colors.white,
                            onPressed:(){
                              final String FirstName= data[index].FirstName;
                              final String SecondName=data[index].SecondName ;
                              final String PhoneNumber= data[index].PhoneNumber.toString();
                              final String TotalPayment=data[index].TotalPayment.toString();
                              final String Address= "Appartment:${data[index].AppartmentNumber}, Street:${data[index].StreetName}\n ,Building:${data[index].BuildingNumber} ,${data[index].City},${data[index].Governorate}";
                              print(Address);
                              Navigator.push(context,MaterialPageRoute(builder:(context)=> new OrderDetails(FirstName,SecondName,PhoneNumber,TotalPayment,Address)));
                            },
                            child: Row(
                              children:<Widget> [
                                Text(
                                  "View Details",
                                  style:TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal,
                                    fontWeight:FontWeight.w400,
                                  ),

                                ),
                                Icon(Icons.arrow_forward_ios),
                              ],

                            ),),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
/////////////////////////////////////////////////////////////////////////////Order Details Page/////////////////////////////////////////////////////////////////////////////////////
class OrderDetails extends StatefulWidget {
  final String FirstName;
  final String SecondName;
  final String Phone;
  final String TotalPayment;
  final String Address;
  OrderDetails(this.FirstName,this.SecondName,this.Phone,this.TotalPayment,this.Address,{Key key}):super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.black,
        centerTitle: true,
        title: Text("Order Details"),
        actions: [
          IconButton(icon: Icon(Icons.article), onPressed:(){})
        ],

      ),
      body:Container(
        padding:EdgeInsets.all(20),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customer:",
              style:TextStyle(
                fontSize: 23,
                fontWeight:FontWeight.bold,
              ),),
            Text(
              '${widget.FirstName} ${widget.SecondName}',
              style:TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              height: 1,
              color: Colors.teal,
            ),
            Stack(
              children: [
                Container(
                  margin:EdgeInsets.only(left:13 ,top:15),
                  width:4,
                  height:330,
                  color:Colors.grey,
                ),
                Column(
                  children: [
                    Information("Phone Number", Icons.phone,widget.Phone),
                    Information("Total Payment",Icons.attach_money,widget.TotalPayment),
                    Information("Address",Icons.location_on,widget.Address),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Container Information(String Header, icon ,String Details) {
    return Container(
      padding:EdgeInsets.symmetric(vertical:10 ),
      child:Row(
        children: [
          Container(
            height:30,
            width:30,
            decoration: BoxDecoration(
              shape:BoxShape.circle,
              color:Colors.teal,
            ),
          ),
          Container(
            height:100,
            width: MediaQuery.of(context).size.width-100,
            child: Card(
              margin:EdgeInsets.fromLTRB(10, 3, 3, 3),
              elevation:0,
              color:Colors.teal[100],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Header,
                          style:TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,

                          ),
                        ),
                        Icon(icon,
                            color:Colors.black),

                      ],
                    ),
                  ),

                  Container(
                    padding:EdgeInsets.fromLTRB(10, 10, 0,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Details,
                          style:TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),

                        ),
                      ],
                    ),
                  ),


                ],

              ),
            ),
          ),

        ],
      ),
    );
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
