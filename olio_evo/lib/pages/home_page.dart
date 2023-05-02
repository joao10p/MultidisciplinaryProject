import 'package:flutter/material.dart';
import 'package:olio_evo/pages/account_page.dart';
import 'package:olio_evo/pages/barcode_page.dart';
import 'package:olio_evo/pages/payment_screen.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import 'cart_page.dart';
import 'chatbot_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  int selectedPage;
  HomePage({Key key, this.selectedPage}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _widgetList = [
    DashboardPage(),
    PaymentScreen(),
    const CartPage(),
    const Center(child: BarcodePage()),
    const AccountPage(),
    const ChatbotPage(),
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();

    if (widget.selectedPage != null) {
      _index = widget.selectedPage;
    }
  }

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
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: true,
      title: const Text(
        "OlivEvo",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartPage()));
          },
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
        Provider.of<CartProvider>(context, listen: false).cartItems.isEmpty
            ? Container()
            : Positioned(
                child: Stack(
                  children: <Widget>[
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.green[900],
                    ),
                    Positioned(
                      top: 4.0,
                      right: 6.0,
                      child: Center(
                        child: Text(
                          Provider.of<CartProvider>(context, listen: false)
                              .cartItems
                              .length
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
