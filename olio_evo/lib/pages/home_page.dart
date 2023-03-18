import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/cart_icons.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>
    _HomePageState();
  
}

class _HomePageState extends State<HomePage>{

  List<Widget> _widgetList=[
    DashboardPage(),
    DashboardPage(),
    DashboardPage(),

  ];

  int _index=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
          CartIcons.home,
          ),
          label: 'Store'
        ),
        BottomNavigationBarItem(
          icon: Icon(
          CartIcons.cart,
          ),
          label: 'MyCart'
        ),
        BottomNavigationBarItem(
          icon: Icon(
          CartIcons.favourites,
          ),
          label: 'Favourites'
        ),
        BottomNavigationBarItem(
          icon: Icon(
          CartIcons.account,
          ),
          label: 'MyAccount'
        ),
      ],
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.shifting,
      currentIndex:  _index,
      onTap: (index){
        setState(()  {
          _index=index;
        });
      },
    ),
    body: _widgetList[_index],
    );
  }


  Widget _buildAppBar(){
      return AppBar(
        centerTitle: true,
        brightness:  Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Text(
          "Olio Evo",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width:10, ),
      Icon(Icons.shopping_cart, color: Colors.white),
      SizedBox(width: 10,),
        ],
      );
  }

}