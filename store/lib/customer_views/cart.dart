import 'package:flutter/material.dart';
import 'product.dart';
import 'product_details.dart';
import '../rest_api.dart';
import 'addcartClass.dart';
import 'home.dart';
import 'profile.dart';
import 'categories.dart';
import 'submit_order.dart';
int con =100;
class Cart extends StatefulWidget {

  final int  CUSID;

  Cart (this.CUSID,{Key key}):super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  int count_orders=0;

  int _currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.monetization_on_outlined),
            onPressed: () async {
              Navigator.push(context,
                 MaterialPageRoute(builder: (context) => UseProm (widget.CUSID )));



            },
          ),
        ],
      ),
      /// to be modified to list of products added to the cart
    body: Container(
      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: FutureBuilder<dynamic>(

                          future: GetCartProducts(widget.CUSID) ,
                          builder: (context,snapshot) {
                            if (snapshot.hasData) {

                              List data = snapshot.data;
                              if(data.length==0)
                              {
                                return Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Cart is empty :) ",

                                        style:TextStyle( fontSize: 40, color: Colors.black, fontWeight:FontWeight.w400,),),
                                      SizedBox(height: 20,),
                                      Text(
                                        " Don't miss our offers!",

                                        style:TextStyle( fontSize: 30, color: Colors.black, fontWeight:FontWeight.w400,),),
                                      SizedBox(height: 40,),
                                      SizedBox(
                                        height: 50,
                                        width: 160,
                                        child: FlatButton(
                                          onPressed: () async {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => CategoriesPage (widget.CUSID)));
                                          },
                                          color: Colors.lightGreen,
                                          padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.shopping_basket_sharp, color: Colors.white,size: 25,),
                                              SizedBox(width: 10,),
                                              Text("Shopping?" ,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15
                                                ),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return   SizedBox(child:CartProducts_view(data,widget.CUSID),height: 2000,);
                            }
                            else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return Text("No Products Yet");
                          },
                        ),
                      ),
    ),

    bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.teal,
        iconSize: 40,
        selectedFontSize: 15,
        items:[
          BottomNavigationBarItem(
            icon: Icon( Icons.home ,  ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.person),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.category_sharp),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if( index == 0)
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Home (widget.CUSID)));
            if( index == 1)
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Account(widget.CUSID)));
            if( index == 2)
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoriesPage (widget.CUSID)));
            if( index == 3)
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Cart(widget.CUSID)));

          });

        },

      ),

    );
  }
}
/// cart products grid
GridView CartProducts_view(data , int CUSid){
  return  GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing:10,
        crossAxisSpacing: 20,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (context,index) =>
          CardCart( product: data[index],
            Press: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductDetails(
                  product: data[index],CUSTID: CUSid,)
                  ,)), CUSID: CUSid,));
}
/// card cart ***************************88
class CardCart extends StatefulWidget {

  final Product product;
  final int CUSID;
  final Function Press;
  const CardCart ({
    Key key,
    this.product,
    this.Press,
    this.CUSID
  }) : super ( key: key);

  @override
  _CardCartState createState() => _CardCartState();
}

class _CardCartState extends State<CardCart> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.Press,

      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),

        decoration: BoxDecoration(
            gradient:
            LinearGradient(
                colors: <Color>[
                  Colors.teal[700],
                  Colors.teal[400],
                  Colors.teal[300],
                  Colors.teal[700],
                  Colors.teal[400],
                  Colors.teal[700],
                  Colors.teal[300],
                  Colors.teal[400],
                ]

            ),
            borderRadius: BorderRadius.circular(16)
        ),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 140,
              child: Image.network(widget.product.image ,
                height: 140,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Text(widget.product.title, style:
                  TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),),
                  SizedBox(height: 5),
                  Text(
                    '\Price: ${widget.product.price} EGP', style:TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text("Qty  ",style:
                      TextStyle(color: Colors.white,
                          fontSize: 20
                      ),),
                      CartCount(product: widget.product,CUSID: widget.CUSID,),
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.favorite_outlined,
                          color: Colors.red[700],
                          size: 35,),
                        onPressed: () {// TODO: add the item to wishlist
                        },),
                      SizedBox(width: 40,),
                      IconButton(
                        icon: Icon(Icons.delete,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () async {

                          dynamic deletedpro = await DeleteFromCart(widget.CUSID, widget.product.id);

                        },),

                    ],

                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
/// Cart count button **************************
class CartCount extends StatefulWidget {
  final Product product;
    final int CUSID;
  const CartCount ({
    Key key,
    this.product,
    this.CUSID
  }) : super ( key: key);

  @override
  _CartCountState createState() => _CartCountState();
}

class _CartCountState extends State<CartCount> {
  int items_num=1;

  @override
  Widget build(BuildContext context) {
    return Row(

      children: <Widget>[
        buildSizedBox( icon : Icons.remove, press: () async {
          dynamic new_qtyy= await dec_qty(widget.CUSID, widget.product.id);
          if( items_num>1) {
            setState(() {
              items_num--;
            });
          }
        },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            items_num.toString().padLeft(2,"0")
            ,style: Theme.of(context).textTheme.headline6,
          ),

        ),
        buildSizedBox(
            icon : Icons.add, press: () async {

          dynamic new_qty= await inc_qty(widget.CUSID, widget.product.id);
          setState(() {
            items_num++;
          });
        }
        ),



      ],
    );
  }
  /// cart counter button/
  SizedBox buildSizedBox({IconData icon , Function press} ) {
    return SizedBox(
      width: 40,
      height: 32,
      child:
      RaisedButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon,
        ),
      ),
    );
  }
}
