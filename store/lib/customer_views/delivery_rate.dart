import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../rest_api.dart';
 class DeliveryRate extends StatefulWidget {

   final int  CUSID;
   final int DMIS;

   DeliveryRate(this.CUSID
       , this.DMIS
      , {Key key}):super(key: key);

   @override
   _DeliveryRateState createState() => _DeliveryRateState();
 }

 class _DeliveryRateState extends State<DeliveryRate> {
   final myController = TextEditingController();
   var myFeedbackText = "COULD BE BETTER";
   double sliderValue = 0;
   IconData myFeedback = FontAwesomeIcons.sadTear;
   Color myFeedbackColor = Colors.red;
   String url;
   /// pop up message  msh 3arfa lesa tamam la2 wallhy 3ady shokrn 3la w2tk m3aya <3 m7tageen n2om nsaly bs :) bye<3
  CreatAlertDialog  (BuildContext context )
   {
     return showDialog( context: context, builder: (context){
       return AlertDialog(
         title: Text("Thanks for your opinion :)"),
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
     return new Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.teal,
         centerTitle: true,
         title: Text("Feedback Delivery Man"),
         actions: <Widget>[
           IconButton(icon: Icon(
               FontAwesomeIcons.solidStar), onPressed: () {
             //
           }),
         ],
       ),
       body: SingleChildScrollView(
         child: Container(
           color: Color(0xffE5E5E5),
           child: Column(
             children: <Widget>[
               Container(child:Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Container(child: Text("On a scale of 1 to 10, how satisfied are you about Delivery Man?",
                   style: TextStyle(color: Colors.teal, fontSize: 22.0,fontWeight:FontWeight.bold),)),
               ),),
               Container(
                 child: Align(
                   child: Material(
                     color: Colors.white,
                     elevation: 14.0,
                     borderRadius: BorderRadius.circular(24.0),
                     shadowColor: Color(0x802196F3),
                     child: Container(
                         width: 350.0,
                         height: 400.0,
                         child: Column(children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(child: Text(myFeedbackText,
                               style: TextStyle(color: Colors.black, fontSize: 22.0),)),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(child: Icon(
                               myFeedback, color: myFeedbackColor, size: 100.0,)),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(child: Slider(
                               min: 0.0,
                               max: 10.0,
                               divisions: 5,
                               value: sliderValue,
                               activeColor: Colors.teal,
                               inactiveColor: Colors.blueGrey,
                               onChanged: (newValue) {
                                 setState(() {
                                   sliderValue = newValue;
                                   if (sliderValue >= 0.0 && sliderValue <= 2.0) {
                                     myFeedback = FontAwesomeIcons.sadTear;
                                     myFeedbackColor = Colors.red;
                                     myFeedbackText = "COULD BE BETTER";
                                   }
                                   if (sliderValue >= 2.1 && sliderValue <= 4.0) {
                                     myFeedback = FontAwesomeIcons.frown;
                                     myFeedbackColor = Colors.yellow;
                                     myFeedbackText = "BELOW AVERAGE";
                                   }
                                   if (sliderValue >= 4.1 && sliderValue <= 6.0) {
                                     myFeedback = FontAwesomeIcons.meh;
                                     myFeedbackColor = Colors.amber;
                                     myFeedbackText = "NORMAL";
                                   }
                                   if (sliderValue >= 6.1 && sliderValue <= 8.0) {
                                     myFeedback = FontAwesomeIcons.smile;
                                     myFeedbackColor = Colors.green;
                                     myFeedbackText = "GOOD";
                                   }
                                   if (sliderValue >= 8.1 && sliderValue <= 10.0) {
                                     myFeedback = FontAwesomeIcons.laugh;
                                     myFeedbackColor = Colors.pink;
                                     myFeedbackText = "EXCELLENT";
                                   }
                                 });
                               },
                             ),),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(12.0),
                             child: Container(child: TextField(
                               onChanged: (value){
                                 /// url = "http://10.0.2.2:5000"+ value.toString();
                               },
                               controller: myController,
                               decoration: new InputDecoration(
                                 border: new OutlineInputBorder(
                                     borderSide: new BorderSide(color: Colors.blueGrey)),
                                 hintText: 'Add Comment',
                               ),
                               style: TextStyle(height: 3.0),
                             ),
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(child: Align(
                               alignment: Alignment.bottomRight,
                               child: RaisedButton(
                                 shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                 color: Colors.teal,
                                 child: Text('Submit',
                                   style: TextStyle(color: Color(0xffffffff)),),
                                 onPressed: () async {
                                   String msgg=" ";
                                  await CreatAlertDialog(context);
                                   if(myController.text == "" ||myController.text == " " )
                                     msgg=" ";
                                   else
                                     msgg=myController.text;
                                   dynamic feedDM= await FeedbackDM(sliderValue,msgg, widget.CUSID,widget.DMIS);
                                 },
                               ),
                             )),
                           ),
                         ],)
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }
 }
