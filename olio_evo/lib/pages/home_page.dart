import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olio_evo/pages/barcode_page.dart';

import '../utils/cart_icons.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _widgetList = [
    DashboardPage(),
    DashboardPage(),
    const Center(child: BarcodePage()),
    DashboardPage(),
    DashboardPage(),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: _buildAppBar(),
            body: _widgetList[_index],
            bottomNavigationBar: SizedBox(
              height: 100,
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.storefront_outlined,
                      ),
                      label: 'Store'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.search,
                      ),
                      label: 'Search'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                      ),
                      label: 'Scan'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.chat_outlined,
                      ),
                      label: 'Chatbot'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      label: 'Account'),
                ],
                selectedItemColor: Colors.white,
                backgroundColor: Colors.lightGreen,
                unselectedItemColor: const Color.fromRGBO(97, 113, 53, 1),
                type: BottomNavigationBarType.fixed,
                iconSize: 30,
                currentIndex: _index,
                onTap: (index) {
                  setState(() {
                    _index = index;
                  });
                },
              ),
            )));
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      title: const Text(
        "OlivEvo",
        style: TextStyle(color: Colors.white),
      ),
      actions: const [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(
          width: 20,
        ),
        Icon(Icons.shopping_cart, color: Colors.white),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
