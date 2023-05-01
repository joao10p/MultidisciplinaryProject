import 'package:flutter/material.dart';
import 'package:olio_evo/pages/cart_page.dart';
import 'package:olio_evo/utils/ProgressHUD.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../provider/loader_provider.dart';

class BasePage extends StatefulWidget {
  BasePage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
            appBar: _buildAppBar(),
            body: ProgressHUD(
              inAsyncCall: loaderModel.isApiCallProcess,
              opacity: 0.3,
              child: pageUI(),
            ));
      },
    );
  }

  Widget pageUI() {
    return null;
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
