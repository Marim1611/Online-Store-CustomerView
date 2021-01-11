import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../rest_api.dart';
import 'calss_category.dart';
import 'category.dart';
import 'product_details.dart';
import 'home.dart';
import 'profile.dart';
import 'cart.dart';
class CategoriesPage extends StatefulWidget {
  final int  CUSID;
  CategoriesPage (this.CUSID,{Key key}):super(key: key);
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _currentIndex = 2; /// for bottom bar
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: !isSearching? Text('All Categories'): TextField(
          decoration: InputDecoration(
              icon: Icon(Icons.search),
              hintText: 'What are you looking for?'
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                setState(() {
                  this.isSearching= !this.isSearching;
                });
              }
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: FutureBuilder<dynamic>(
                future: GetCategories(),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    if(data.length==0)
                    {
                      return Center(
                        child: Text(
                          "NO Categories Yet",
                          style:TextStyle( fontSize: 18, color: Colors.black, fontWeight:FontWeight.w400,),),
                      );
                    }
                    return SizedBox(child:  CategoriesGrisView(data,widget.CUSID),height: 1000, );
                  }
                  else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Text("No products Yet");
                },
              ),

            ),

            SizedBox( height: 10,),

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
            icon: Icon( Icons.home ,  ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.person),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.category_sharp),
            label: 'categories',
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
}
///
GridView CategoriesGrisView(data, int CUSTID){

  return  GridView.builder(
      itemCount: data.length,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing:20,
        crossAxisSpacing: 20,
        childAspectRatio:2.5,
      ),
      itemBuilder: (context,index) =>
          CategoryCard(  categorym: data[index],
            Press: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => Category(
            category: data[index],CUSID: CUSTID,))) )
  );
}
/// Category Card
class CategoryCard extends StatelessWidget {
  final MyCategory categorym;
  final Function Press;
  const CategoryCard({
    Key key,
    this.categorym,
    this.Press,
  }) : super ( key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Press,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient:  LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [
                  Colors.teal[700],
                  Colors.teal[400],
                  Colors.teal[300],
                  Colors.teal[700],
                  Colors.teal[400],
                  Colors.teal[700],
                  Colors.teal[300],
                  Colors.teal[400],
                  Colors.teal[700],

                ],)),

          child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage:   NetworkImage(categorym.imageC)  ,
                      ),
                  ),
                  SizedBox(width: 10,),
                  Center(child: Text(categorym.name, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)),
                ]
              ),


          ),
        ),
    );
  }
}
