import 'package:flutter/material.dart';
import 'package:olio_evo/pages/account_page.dart';
import 'package:olio_evo/pages/barcode_page.dart';
import 'package:olio_evo/pages/payment_screen.dart';

import 'chatbot_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _widgetList = [
    DashboardPage(),
    DashboardPage(),
    PaymentScreen(),
    const Center(child: BarcodePage()),
    const ChatbotPage(),
    const AccountPage(),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: _buildAppBar(),
            body: IndexedStack(index: _index, children: _widgetList),
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
