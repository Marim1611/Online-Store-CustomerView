import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../rest_api.dart';
import 'product.dart';
import 'product_details.dart';
import 'cart.dart';
import 'profile.dart';
import 'categories.dart';

class Home extends StatefulWidget {

  final int  CUSID;

  Home (this.CUSID,{Key key}):super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool isSearching = false;
  String url;
  var Data;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: !isSearching? Text('Home page'): TextField(
          decoration: InputDecoration(
              icon: Icon(Icons.search),
              hintText: 'What are you looking for?',
            suffixIcon: GestureDetector( onTap: () async{
             // Data = await GetData(url)
            },)
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                setState(() {
                  this.isSearching= !this.isSearching;
                });
              }
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: Container(
          height: 2000,
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
           padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              /// Images Random View

              SizedBox(height: 10,),
              Text("BEST SELLERS",style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),),
              SizedBox(height: 10,),
              /// BEST SELLERS
              FutureBuilder<dynamic>(
                future: GetBestSellerProducts(),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    if(data.length==0)
                    {
                      return Center(
                        child: Text(
                          "NO products Yet",
                          style:TextStyle( fontSize: 40 , color: Colors.white, fontWeight:FontWeight.w400,),),
                      );
                    }
                    return SizedBox(child: BestSellerProducts(data,widget.CUSID),height: 400,);
                  }
                  else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Text("No products Yet");
                },
              ),

              SizedBox(height: 10,),
              Text("Current Offers",style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),),
              SizedBox(height: 10,),
              /// OFFERS
              FutureBuilder<dynamic>(
                future:   GetProductsWithOffers() ,
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    if(data.length==0)
                    {
                      return Center(
                        child: Text(
                          "NO Offers Yet",
                          style:TextStyle( fontSize: 40, color: Colors.white, fontWeight:FontWeight.w400,),),
                      );
                    }
                    print("MARIMMMM "+widget.CUSID.toString());
                    return SizedBox(child: OrdersHasOffer(data,widget.CUSID),height: 400,);
                  }
                  else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Text("No Offers Yet");
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
              label: 'categories',
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
/// Best Seller products
ListView BestSellerProducts(data , int CusID){
  return  ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount:  data.length,
      itemBuilder: (context,index)=>
          ItemCard(product: data[index],
              Press:  () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductDetails(
                    product: data[index],CUSTID: CusID,))
              ),
          )
  );
}
/// offers product
ListView OrdersHasOffer(data,int CusID){
  return  ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount:  data.length,
      itemBuilder: (context,index)=>
          ItemCard(product: data[index],
              Press:  () {
            print("hiii "+ CusID.toString());
            Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductDetails(
                    product: data[index],CUSTID: CusID,))
              ); }
          )
  );
}
/// products Card
/// Item Card Class*********************************************
class ItemCard extends StatelessWidget {

  final Product product;
  final Function Press;
  const ItemCard({
    Key key,
    this.product,
    this.Press
  }) : super ( key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Press,
      child: Container(
        padding: EdgeInsets.all(30),
      color: Colors.white,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 200,
                child: Image.network(product.image,
                    fit:BoxFit.fill
                   )
            ),
            SizedBox(height:5 ,),
            Text( "${product.title}", style:
            TextStyle(color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 25
            ),),
            SizedBox(height: 5,),
            Text(
              '\ ${product.price} EGP', style:TextStyle(color: Colors.teal,

                fontSize: 20
            ),),
            SizedBox(height: 5,),
            Text(
              '\ ${product.discount} %', style:TextStyle(color: Colors.teal,

                fontSize: 20
            ),),

            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  color: Colors.teal,
                  onPressed: () {
                    ///add the product to cart
                  },
                ),
                SizedBox(width: 10,),
                IconButton(
                  icon: Icon(Icons.favorite_outline_rounded),
                  color: Colors.red[800],
                  onPressed: () {
                   ///add to wish list
                  },
                ),
              ],
            )

          ],
        )
      ),
    );
  }
}

