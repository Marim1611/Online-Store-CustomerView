import 'package:flutter/material.dart';
import 'customer_SignUP.dart';
import '../rest_api.dart';
import '../customer_views/home.dart';
class CustomerLogin extends StatefulWidget {
  @override
  _CustomerLoginState createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  Map<String,dynamic> FormData = {
    'Email':null,
    'Password':null
  };
  final _formKey = GlobalKey<FormState>();
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
            child: Column(
            children: [
              Row(
                children: [
                  RotatedBox(quarterTurns: -1 ,child: TextLoginOrSignUP("Log In")),
                  Text( "Where shopping \n is like \n pleasure",
                    style: TextStyle( fontSize: 30.0,),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                style: TextStyle(),
                decoration: InputDecoration(
                    hintText: "Email",
                    icon: Icon(Icons.email)
                ),
                onChanged: (val){
                  setState(() => FormData['Email'] = val);
                },
                validator: (val) => val.isEmpty ? "Please fill in your email" : null,
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                style: TextStyle(),
                decoration: InputDecoration(
                    hintText: "Password",
                    icon: Icon(Icons.lock)
                ),
                onChanged: (val){
                  setState(() => FormData['Password'] = val);
                },
                validator: (val) {
                  if(val.isEmpty){return "Please fill in your password";}
                  if(val.length<6){return "Incorrect Password";}
                  return null;
                },
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.teal,
                  child: Text("LogIn", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      //if the form from the client side is valid
                      print("All Valid at the client side :)");
                      //go and check if this credentials is valid from the server (DB) side
                      //i.e check if this account exists and if the email and password matches (are correct)
                      //Server Validation Side
                      dynamic customerData = await ApiService.getCusotmer(FormData['Email'],FormData['Password']);

                      if(customerData == null) { setState(() => error = "Invalid email or password!"); }
                      else {
                        setState(() => error = "");
                        //navigate to the customer home page
                        print(customerData);
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home( customerData["Id"])));
                      }
                    }
                  }
              ),
              SizedBox(height: 20.0,),
              Text(error, style: TextStyle(color: Colors.red,fontSize: error.isEmpty ? 0.0 : 14.0),),
              switchToLoginOrSignupCustomer(context,"Your first time?","Sign Up"),
            ],
              ),
          ),
        ),
      ),
    );
  }
}

Widget TextLoginOrSignUP(String text){
  return Container(
    padding: EdgeInsets.all(12.0),
    child: Text(text,
    style: TextStyle(
      color: Colors.teal,
      fontSize: 60.0,
      fontWeight: FontWeight.bold,
    ),),
  );
}

Widget switchToLoginOrSignupCustomer(BuildContext context, String stateText, String switchModeText){
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(stateText),
        FlatButton(
            onPressed: (){
              if(switchModeText=="Sign Up"){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSignUp()));
              }else{
                Navigator.pop(context);
                }
              },
            child: Text(switchModeText, style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),)),
      ],
    ),
  );
}