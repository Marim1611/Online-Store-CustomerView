import 'package:customer_views/customer_views/comment_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'product.dart';
import 'cart.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:customer_views/rest_api.dart';
import 'comment_product.dart';
import 'show_reviews.dart';

class ProductDetails extends StatelessWidget {
  final int CUSTID;
  final Product product;

  const ProductDetails({Key key, this.product, this.CUSTID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ///dynamic rateing=double.parse(showrate(product.id).toString());
   ///String ratee= rateing.toString();
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text(product.title , style: TextStyle(color: Colors.white, fontSize: 30),),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Cart(CUSTID)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
                      SizedBox(
                        height: 500,
                      width: 350,
                      child: Image.network(product.image, fit:BoxFit.fill ,)),
                    SizedBox(height: 20,),
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(  children: <Widget>[
                          Text(product.price.toString() + ".00 EGP",
                            style: TextStyle(
                                color: Colors.white,
                                height: 1.5,fontSize: 25
                            ),),
                          SizedBox(width: 20,),
                          /// SHOW Rate only
                          RatingBar.builder(
                            itemCount: 5,
                            //  '${widget.comment['Message']}'
                            initialRating: 3 ,/// double.parse( rateing),
                            itemSize: 40,
                            // direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 10,
                            ),

                          ),
                        ],
                        ),
                      ),
                      SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text("Sold "+product.freqency.toString() + " times",
                                style: TextStyle(
                                    color: Colors.white,
                                    height: 1.5,fontSize: 22
                                ),),
                              SizedBox(width: 30,),
                              SizedBox(
                                height: 50,
                                width: 160,
                                child: FlatButton(
                                  onPressed: () async {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ShowReviews(product.id)));

                                  },
                                  color: Colors.lightGreen,
                                  padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.star_half, color: Colors.white,size: 25,),
                                      SizedBox(width: 2,),
                                      Text("View Reviews" ,
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
                        ),
            SizedBox(height: 30,),
                       Container(
                         height: 3,
                         width: 350,
                         color: Colors.white,
                       ),
                       SizedBox(height: 20,),
                        Text("Details ",
                          style: TextStyle(

                              color: Colors.white,
                              height: 1.5,fontSize: 25
                          ),),
            SizedBox(height: 15,),
                        SizedBox(
                          height: 130,
                          width: 400,
                          child: SingleChildScrollView(
                            child: Card(
                              child:Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(product.description,
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      height: 1.5,fontSize: 20
                                  ),),
                              ),
                            ),
                          ),
                        ),
            SizedBox(height: 40,),
            SizedBox(
              height: 70,
              width: 350,
              child: FlatButton(
                onPressed: () async {
                  /// add this product to cart
                  /// quantity here always = 1 it can be changed in the cart its self
                  dynamic addingcart= await AddToCart(CUSTID, product.id, 1);
                },
                color: Colors.lightGreen,
                padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.shopping_cart , color: Colors.white,size: 40,),
                    SizedBox(width: 40,),
                    Text("Add to cart" ,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35
                      ),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 3,
              width: 350,
              color: Colors.white,
            ),
            SizedBox(height: 20,),
            Text("Rate the product?",
              style: TextStyle(

                  color: Colors.white,
                  height: 1.5,fontSize: 20
              ),),
            SizedBox(height: 20,),
            RatingBar.builder(
              itemCount: 5,
              initialRating: 0,
              itemSize: 60,
              // direction: Axis.horizontal,
              allowHalfRating: true,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 10,
              ),
              onRatingUpdate: (rating)async {
                dynamic rater= await  Ratepro(CUSTID, rating,product.id  );
                print(rating);
              },
            ),
            SizedBox(height: 20,),
            SizedBox(
              height: 50,
              width: 165,
              child: FlatButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CommentProduct(CUSTID, product.id)));
                },
                color: Colors.grey[300],
                padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.edit_outlined, color: Colors.teal,size: 25,),
                    SizedBox(width: 4,),
                    Text("Write Review?" ,
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 15
                      ),),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40,),



          ],
        ),

      ),
    );
  }
}

