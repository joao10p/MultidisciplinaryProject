import 'package:flutter/material.dart';
import 'package:olio_evo/provider/cart_provider.dart';
import 'package:olio_evo/provider/loader_provider.dart';
import 'package:olio_evo/shared_service.dart';
import 'package:olio_evo/utils/ProgressHUD.dart';
import 'package:olio_evo/widgets/unauth_widget.dart';
import 'package:olio_evo/widgets/widget_cart_product.dart';
import 'package:provider/provider.dart';

import '../shared_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    var cartItemsList = Provider.of<CartProvider>(context, listen: false);
    cartItemsList.resetStreams();
    cartItemsList.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
        if (loginModel.hasData) {
          if (loginModel.data) {
            return Consumer<LoaderProvider>(
                builder: (context, loaderModel, child) {
              return Scaffold(
                
                body: ProgressHUD(
                  inAsyncCall: loaderModel.isApiCallProcess,
                  opacity: 0.3,
                  child: _cartItemsList(),
                ),
              );
            });
          } else {
            return const UnAuthWidget();
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _cartItemsList() {
    return Consumer<CartProvider>(
        // ignore: missing_return
        builder: (context, cartModel, child) {
      if (cartModel.cartItems != null && cartModel.cartItems.isNotEmpty) {
        return SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: cartModel.cartItems.length,
                  itemBuilder: (context, index) {
                    return CartProduct(data: cartModel.cartItems[index]);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Provider.of<LoaderProvider>(context, listen: false)
                        .setLoadingStatus(true);
                    var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);

                    cartProvider.updateCart((val) {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(false);
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.green,
                    shape: const StadiumBorder(),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      Icon(
                        Icons.sync,
                        color: Colors.white,
                      ),
                      Text(
                        "Update Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "€ ${cartModel.totalAmount}",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.redAccent,
                        shape: const StadiumBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Checkout",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
      } else if (cartModel.cartItems.isEmpty) {
        return Column(children: [
          const Text("The cart is empty"),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "€ 0.0",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: Colors.redAccent,
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "Checkout",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]);
      }
    });
  }
}
