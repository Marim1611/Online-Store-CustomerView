import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../salesman_view/SalesMan_Product.dart';
import 'employee_login.dart';
import '../rest_api.dart';

class EmployeeSignUp extends StatefulWidget {
  @override
  _EmployeeSignUpState createState() => _EmployeeSignUpState();
}

class _EmployeeSignUpState extends State<EmployeeSignUp> {
  Map<String,dynamic> FormData = {
    'FirstName':null,
    'SecondName':null,
    'PhoneNumber':null,
    'Email':null,
    'Password':null,
    'Position':null,
    'Governorate':null,
    'City':null,
    'StreetName':null,
    'BuildingNumber':null,
    'AppartmentNumber':null,
  };
  List<String> Position = [
    "HR",
    "SalesMan",
    "DeliveryMan"
  ];
  List<String> Governorates = [
    "Cairo",
    "Giza",
    "Alexandria",
  ];
  Map<String, List<String>> Cities = {
    "Cairo":["Maadi","Nasr City","New Cairo"],
    "Giza":["Giza","6th of October City","Agouza", "Dokii","Sheikh Zayed City"],
    "Alexandria":["Abou Kir","Agami","Borg El Arab","Cleopatra","El Montaza","Gleem","Ibrahimya","Maamoura","Mandara","Miami","Raml Station","San Estefano"]
  };

  final _formKey = GlobalKey<FormState>();
  String error = "";
  bool _isCityDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    RotatedBox(quarterTurns: -1, child: TextLoginOrSignUP("Apply Now!")),
                    Text("It seems ... \nwe've the job \nof your dreams",
                      style: TextStyle( fontSize: 30.0),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                //FirstName
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "First Name",
                    icon: Icon(Icons.perm_identity_rounded),
                  ),
                  onChanged: (val){
                    setState(() => FormData['FirstName'] = val);
                  },
                  validator: (val) {
                    if(val.isEmpty){return "Please fill in your First Name";}
                    if(val.length>20){return "First Name length can't exceed 20 characters";}
                    return null;
                  },
                ),
                SizedBox(height: 20.0,),
                //SecondName
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Second Name",
                    icon: Icon(Icons.perm_identity_rounded),
                  ),
                  onChanged: (val){
                    setState(() => FormData['SecondName'] = val);
                  },
                  validator: (val) {
                    if(val.isEmpty){return "Please fill in your Second Name";}
                    if(val.length>20){return "Second Name length can't exceed 20 characters";}
                    return null;
                  },
                ),
                SizedBox(height: 20.0,),
                //PhoneNumber
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Phone Number (11 digits)",
                    icon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val){
                    setState(() => FormData['PhoneNumber'] = val);
                  },
                  validator: (val) => (val.length!=11) ? "Phone Number must be 11 digits" : null,
                ),
                SizedBox(height: 20.0,),
                //Position
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "The Job you want to apply on",
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
                  validator: (val) => (val==null) ? "Please Choose the job you want to apply to" : null,
                ),
                SizedBox(height: 20.0,),
                //Email
                TextFormField(
                  obscureText: false,
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
                    if(val.length<6){return "Password length must be greater than 6 characters";}
                    return null;
                  },
                ),
                SizedBox(height: 20.0,),
                //Governorate
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Governorate",
                    icon: Icon(Icons.location_on_outlined),
                  ),
                  items: Governorates.map((Governorate) {
                    return DropdownMenuItem(
                        value: Governorate,
                        child: Text("$Governorate"));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      FormData["Governorate"] = val;
                      FormData["City"] = null;
                      _isCityDisabled = false;
                    });
                  },
                  validator: (val) => (val==null) ? "Please Choose your Governorate" : null,
                ),
                SizedBox(height: 20.0,),
                //City
                DropdownButtonFormField(
                  value: FormData["City"],
                  decoration: InputDecoration(
                    hintText: "City",
                    icon: Icon(Icons.location_on_outlined),
                  ),
                  items: _isCityDisabled? [] : (Cities["${FormData["Governorate"]}"].map((City) {
                    return DropdownMenuItem(
                        value: City,
                        child: Text("$City"));
                  })).toList(),
                  onChanged: _isCityDisabled? null : (val) {
                    setState(() {
                      FormData["City"] = val;
                    });
                  },
                  validator: (val) => (val==null) ? "Please Choose your City" : null,
                ),
                SizedBox(height: 20.0,),

                //textformfield (StreetName)
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Street Name/No.",
                    icon: Icon(Icons.streetview),
                  ),
                  onChanged: (val){
                    setState(() => FormData['StreetName'] = val);
                  },
                  validator: (val) => (val.isEmpty) ? "Please fill in your street name/no." : null,
                ),
                SizedBox(height: 20.0,),
                //textformfield (BuildingNumber)
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Building Number",
                    icon: Icon(Icons.build),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val){
                    setState(() => FormData['BuildingNumber'] = val);
                  },
                  validator: (val) => (val.isEmpty) ? "Please fill in your Building Number" : null,
                ),
                SizedBox(height: 20.0,),
                //textformfield (AppartmentNumber)
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Appartment Number",
                    icon: Icon(Icons.build),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val){
                    setState(() => FormData['AppartmentNumber'] = val);
                  },
                  validator: (val) => (val.isEmpty) ? "Please fill in your Appartment Number" : null,
                ),
                SizedBox(height: 20.0,),

                //Sign up (submit) button
                RaisedButton(
                    shape: StadiumBorder(),
                    color: Colors.teal,
                    child: Text("Apply now!", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    onPressed: () async {
                      print(FormData);
                      if(_formKey.currentState.validate()){
                        //if the form from the client side is valid
                        print("All Valid at the client side:)");
                        //go and check if this credentials is valid from the server (DB) side
                        //i.e check if this account exists and if the email and password matches (are correct)

                        //Server Validation Side
                        dynamic employeeData = await ApiService.addEmployee(FormData);
                        if(employeeData == null) { setState(() => error = "This Account already exists!"); }
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
                switchToLoginOrSignupEmployee(context,"Have we met before?","Login"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
