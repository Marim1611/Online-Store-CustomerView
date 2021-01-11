import 'package:flutter/material.dart';
import '../rest_api.dart';
class Complaint extends StatefulWidget {
  final int CUSID;
  Complaint (this.CUSID,{Key key}):super(key: key);
  @override
  _ComplaintState createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {

     int count_complaint = 0;
     final myController = TextEditingController();
    CreatAlertDialog (BuildContext context )
    {
      return showDialog( context: context, builder: (context){
        return AlertDialog(
          title: Text("Your Complaint is sent successfully!"),
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
        title: Text('Make a Complaint'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body:Builder(builder:(context){
        return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Container(
                width: 400,
                height: 400,
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
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            " If you have any problem write it down and we will send you as fast as we could :)",
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
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
                                      hintText: "Write your complaint here.."),
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
            SizedBox(height: 20,),
            FlatButton(onPressed: () async {
              count_complaint++;
              if( myController.text != ""){
                dynamic complaint_makes= await MakeComplaints(widget.CUSID , myController.text);

                CreatAlertDialog(context);
              }
            },
              minWidth: 350,
              height: 50,
              child: Text("Send",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                ),),
              color: Colors.teal[300],
            )
          ],
        ),
      );
      }

      )
    );
  }
}
