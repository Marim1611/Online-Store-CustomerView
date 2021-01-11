import 'package:flutter/material.dart';
import '../salesman_view/SalesMan_Product.dart';
import 'employee_SignUP.dart';
import '../rest_api.dart';

class EmployeeLogin extends StatefulWidget {
  @override
  _EmployeeLoginState createState() => _EmployeeLoginState();
}

class _EmployeeLoginState extends State<EmployeeLogin> {
  Map<String,dynamic> FormData = {
    'Email':null,
    'Password':null,
    'Position':null
  };
  List<String> Position = [
    "HR",
    "SalesMan",
    "DeliveryMan"
  ];
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
                    Text( "Where working \n is like \n pleasure",
                      style: TextStyle( fontSize: 30.0,),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                //Email
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
                //Password
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
                //Job
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Position",
                    icon: Icon(Icons.work),
                  ),
                  items: Position.map((position){
                    return DropdownMenuItem(
                      value:position,
                      child: Text("$position"),
                    );
                  }).toList(),
                  onChanged: (val){ setState(() {
                    FormData["Position"]= val;
                  });},
                  validator: (val) => (val==null) ? "Please Choose your position" : null,
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                    shape: StadiumBorder(),
                    color: Colors.teal,
                    child: Text("Let's Work!", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        //if the form from the client side is valid
                        print("All Valid at the client side :)");
                        //go and check if this credentials is valid from the server (DB) side
                        //i.e check if this account exists and if the email and password matches (are correct)
                        //Server Validation Side
                        dynamic employeeData = await ApiService.getEmployee(FormData);

                        if(employeeData == null) { setState(() => error = "Invalid email or password!"); }
                        else {
                          setState(() => error = "");
                          //navigate to the employee home page based on his position
                          String Position = FormData["Position"];
                          if(Position == "HR"){
                            //Mariam Zain
                            //Navigate to HR home Screen
                            //employeeData is a map holding the tuple of the employee
                            //To know it's exactly content visit lib/rest_api/ in function getEmployee check the comments
                          }
                          else if(Position == "SalesMan"){
                            //Navigate to SalesMan home Screen
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesManView_Product(UserData: employeeData,)));
                          }
                          else{
                            //Hala
                            //Navigate to DeliveryMan home screen
                            //employeeData is a map holding the tuple of the employee
                            //To know it's exactly content visit lib/rest_api/ in function getEmployee check the comments
                          }
                        }
                      }
                    }
                ),
                Text(error, style: TextStyle(color: Colors.red,fontSize: error.isEmpty ? 0.0 : 14.0),),
                SizedBox(height: 20.0,),
                switchToLoginOrSignupEmployee(context,"Want to apply for a job?","Apply now!"),
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

Widget switchToLoginOrSignupEmployee(BuildContext context, String stateText, String switchModeText){
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(stateText),
        FlatButton(
            onPressed: (){
              if(switchModeText=="Login"){
                Navigator.pop(context);
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeSignUp()));
              }
            },
            child: Text(switchModeText, style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),)),
      ],
    ),
  );
}