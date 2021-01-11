import 'package:flutter/material.dart';
import 'package:customer_views/rest_api.dart';
import '../rest_api.dart';
import 'OrderDetails.dart';
import 'cart.dart';
import 'calss_order.dart';
import 'delivery_rate.dart';

 class ShowReviews extends StatefulWidget {
   final int ProID;
   ShowReviews( this.ProID, {Key key}):super(key: key);
   @override
   _ShowReviewsState createState() => _ShowReviewsState();
 }

 class _ShowReviewsState extends State<ShowReviews> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         elevation: 0,
         backgroundColor: Colors.teal,
         title: Text('Reviews',
         ),
         centerTitle: true,
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

            future: showcomment(widget.ProID),
             builder: (context,snapshot) {
               if (snapshot.hasData) {

                 List data = snapshot.data;
                 if(data.length==0)
                 {
                   print( ")00000000000000000");
                   return Center(
                     child: Text(

                       "No Reviews Yet ",
                       style:TextStyle( fontSize: 40, color: Colors.black, fontWeight:FontWeight.w400,),),
                   );
                 }

                 return   Comments_view(data);
               }
               else if (snapshot.hasError) {
                 return Text("${snapshot.error}");
               }
               return Text("No Reviews Yet");
             },
           ),
         ),

       ),



     );
   }
 }
/// comments  grid
GridView Comments_view(data ){
  return  GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing:10,
        crossAxisSpacing: 10,
        childAspectRatio: 3,
      ),
      itemBuilder: (context,index) =>
          CommentCard ( comment: data[index]
          ));
}
/// comment card
class CommentCard extends StatefulWidget {
  final dynamic comment;

  const CommentCard({Key key, this.comment}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:SizedBox(
        child: SingleChildScrollView(
          child: Card(
            child:Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('${widget.comment['Message']}',
                style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.5,fontSize: 20
                ),),
            ),
          ),
        ),
      ),
    );
  }
}
