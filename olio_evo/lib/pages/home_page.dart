import 'package:flutter/material.dart';
import 'package:olio_evo/pages/account_page.dart';
import 'package:olio_evo/pages/barcode_page.dart';
import 'package:olio_evo/pages/order_detail.dart';
import 'package:olio_evo/pages/orders_page.dart';
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
    const CartPage(),
    const BarcodePage(),
    const ChatbotPage(),
    const AccountPage(),
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
          height: MediaQuery.of(context).size.height * 0.107,
          child: BottomNavigationBar(
            selectedLabelStyle: TextStyle(fontSize: 16),
            unselectedLabelStyle: TextStyle(fontSize: 15),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.storefront_outlined,
                    color: Colors.green,
                  ),
                  label: 'Store'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                  label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.green,
                  ),
                  label: 'Scan'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_outlined,
                    color: Colors.green,
                  ),
                  label: 'Chatbot'),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.green,
                ),
                label: 'Account',
              ),
            ],
            selectedItemColor: Color.fromARGB(255, 17, 17, 17),
            backgroundColor: Colors.white,
            unselectedItemColor: const Color.fromRGBO(97, 113, 53, 1),
            type: BottomNavigationBarType.fixed,
            iconSize: 30,

            currentIndex: _index,
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
            // Imposta lo stile delle label come invisibile
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
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
            Icons.shopping_cart_rounded,
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
