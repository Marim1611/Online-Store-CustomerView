import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calss_category.dart';
import 'product.dart';
import 'product_details.dart';
import '../rest_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'cart.dart';


bool isSearching = false;

class Category extends StatelessWidget {

  final int  CUSID;
  final MyCategory category;
  const Category
      ({Key key, this.category , this.CUSID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Cart(CUSID)));
            },
          ),
        ],
      ),
      body:  Container(
        child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: FutureBuilder<dynamic>(
                future: CategoryProducts(category.ID_C) ,
                builder: (context,snapshot) {
                  if (snapshot.hasData) {

                    List data = snapshot.data;
                    if(data.length==0)
                    {
                      return Center(
                        child: Text(
                          "NO Products Yet",
                          style:TextStyle( fontSize: 18, color: Colors.black, fontWeight:FontWeight.w400,),),
                      );
                    }
                    return SizedBox(child:CategoryrProducts_view(data,CUSID) );
                  }
                  else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Text("No Offers Yet");
                },
              ),
            ),
      )

      ,
    ) ;
  }
}
///
GridView CategoryrProducts_view(data, int CUSID){
  return  GridView.builder(
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing:20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.9,
      ),
      itemBuilder: (context,index) =>
          ItemCard( product: data[index],
            Press: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductDetails(
                  product: data[index],CUSTID: CUSID,)
                  ,)), CUSID: CUSID,));
}

/// Item Card Class*********************************************
class ItemCard extends StatelessWidget {

  final Product product;
  final Function Press;
  final int  CUSID;
  const ItemCard({
    Key key,
    this.product,
    this.Press,
    this.CUSID
  }) : super ( key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Press,
      child: Container(
        padding: EdgeInsets.all(10),
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
            borderRadius: BorderRadius.circular(20)

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: 160,
                width: 130,
                child: Image.network(product.image)),
            SizedBox(width: 4,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(product.title, style:
                TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),),
                SizedBox(height: 10,),
                Text(
                  '\ ${product.price} EGP', style:TextStyle(color: Colors.white,

                    fontSize: 25
                ),),


                SizedBox(height: 5),
                RatingBar.builder(
                  itemCount: 5,
                  initialRating: 5,
                  itemSize: 30,
                  // direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 10,
                  ),

                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    FlatButton(
                      onPressed: () async {
                        /// add this product to cart
                        /// quantity here always = 1 it can be changed in the cart its self
                          dynamic addingcart= await AddToCart(CUSID, product.id, 1);
                      },
                      color: Colors.lightGreen,
                      padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.shopping_cart , color: Colors.white,),
                          SizedBox(width: 2,),
                          Text("Add to cart" ,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),),
                        ],
                      ),
                    ),
                    SizedBox( width : 5),

                    IconButton(
                      icon: Icon(Icons.favorite_outlined,
                          size: 40),

                      color: Colors.red[700],

                      onPressed: () {
                        // TODO: add to wish list
                      },),
                  ],
                ),
              ],
            ),



          ],
        ),
      ),



    );
  }
}


