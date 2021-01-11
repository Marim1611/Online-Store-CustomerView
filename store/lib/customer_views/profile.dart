
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'make_complaint.dart';
import 'cart.dart';
import 'home.dart';
import 'categories.dart';
import 'myorders.dart';
//***********************************************
class ListTiles extends StatelessWidget {

  String text;
  IconData icon;
  Function ontap;

  ListTiles(this.text, this.icon, this.ontap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: Colors.grey, // change this later according to the color we all agree on
        onTap: ontap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 20,
                      )
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
    );
  }
}
//**************************************************************************
class Account extends StatefulWidget {
  final int  CUSID;
  //final int  CUSID;
  Account(this.CUSID,{Key key}):super(key: key);
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int _currentIndex =1;
  PickedFile imageFile;
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('My Account'),
          centerTitle: true,
          backgroundColor: Colors.teal[400],
          actions: <Widget>[
            IconButton(icon: Icon(Icons.logout),
                onPressed: (){
              // to do log out
                })

          ],
        ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(

              height: 200,
              child: Stack(
                children: <Widget>[
                  Container(),
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient:
                        LinearGradient(
                            colors: <Color>[
                              Colors.teal[700],
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
                    ),
                  ),
                  Column(
                    mainAxisSize:MainAxisSize.min,
                    children: [
                      profileImage(),
                      // ytbdl b username
                      Text( "8ayreh l 2sm el user", style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),),
                    ],

                  ),
                ],
              ),
            ),
            ListTiles('My Orders', Icons.local_shipping_outlined,
                    (){  Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>MyOrders(widget.CUSID)));}),
            ListTiles('My Wishlist', Icons.favorite
                , (){}),
            ListTiles('Personal Information', Icons.person_pin,
                    (){}),
            ListTiles('Make a Complaint ?', Icons.feedback,
                    (){ Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Complaint(widget.CUSID))); }),

           // ListTiles('Rate Us', Icons.star_border,
              //      (){  Navigator.pushNamed(context, '/feedback');}),
            ListTiles('Share with Friends', Icons.share,
                    (){}),
            ListTiles('Need Help?', Icons.help,
                    (){}),
          ],
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
            icon: Icon( Icons.home ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.person),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.category_sharp),
            label: 'Cateogry',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print('$_currentIndex ');
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
  //***********************************************************
  Widget bottomsheet()
  {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20
      ,vertical: 20),
      child: Column(
        children: <Widget>[
          Text('Choose Profile Picture',
          style: TextStyle(
            fontSize: 20
          ),
          ),
          SizedBox( height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon( Icons.camera),
                onPressed: (){
                  takephoto(ImageSource.camera);

                },
                label: Text('Camera'),
              ),
              FlatButton.icon(
                icon: Icon( Icons.image),
                onPressed: (){
                  takephoto(ImageSource.gallery);

                },
                label: Text('Gallery'),
              )

            ],

          )
        ],
      ),
    );

  }
void takephoto ( ImageSource source) async {
    final PickedFile = await picker.getImage(
      source: source,
    );
}
  Widget profileImage(){
    return Center(
      child: Stack (
        children: <Widget>[
          Container(
             height: 150,
            child: Align(
              child: CircleAvatar(
                radius: 60,

                backgroundImage: imageFile == null
                    ? AssetImage("assets/defaultImage.jpg")
                    : FileImage(File(imageFile.path)),

              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 145,
            child: InkWell(
              onTap: (){
                showModalBottomSheet<void>(
                context: context,
                builder:((builder)=> bottomsheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey[700],
                size:28
              ),
            ),
          )

        ],

      ),
    );
  }
}
class MyCustomClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path= Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 0);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
   return true;
  }
  
}