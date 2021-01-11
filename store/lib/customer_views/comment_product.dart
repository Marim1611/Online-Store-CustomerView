import 'package:flutter/material.dart';
import 'product.dart';
import '../rest_api.dart';

class CommentProduct extends StatefulWidget {
  final int CUSID;
  final int ProID;
  CommentProduct(this.CUSID , this.ProID, {Key key}):super(key: key);

  @override
  _CommentProductState createState() => _CommentProductState();
}

class _CommentProductState extends State<CommentProduct> {

  final myController = TextEditingController();
  CreatAlertDialog (BuildContext context )
  {
    return showDialog( context: context, builder: (context){
      return AlertDialog(
        title: Text("Thanks For your review"),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Write Review'),
          centerTitle: true,
          backgroundColor: Colors.teal,
          elevation: 0,

        ),
        body:Builder(builder:(context){
          return SingleChildScrollView(
            child: Container(
              height: 1000,
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    child: Container(
                      width: 400,
                      height: 400,
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  "Help Us to improve our customer service :)",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30
                                  ),),
                                SizedBox(height: 10,),
                                Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: myController,
                                        maxLines: 13,
                                        decoration: InputDecoration.collapsed(
                                            hintText: "Write your review here.."),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(onPressed: () async {

                    if( myController.text != ""){
                     dynamic reviewmakes= await Commentpro(widget.CUSID , myController.text,widget.ProID);
                      CreatAlertDialog(context);
                   }
                  },
                    minWidth: 350,
                    height: 50,
                    child: Text("Submit Review",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),),
                    color: Colors.lightGreen,
                  )
                ],
              ),
            ),
          );
        }

        )
    );
  }
}
