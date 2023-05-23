import 'package:flutter/material.dart';
import 'package:olio_evo/pages/checkout_base.dart';
import 'package:olio_evo/pages/home_page.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class OrderSuccessWidget extends CheckoutBasePage {
  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState
    extends CheckoutBasePageState<OrderSuccessWidget> {
  @override
  void initState() {
    currentPage = 2;
    showBackButton = false;

    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.createOrder();

    super.initState();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(builder: (context, orderModel, child) {
      if (orderModel.isOrderCreated) {
        return Center(
          child: Container(
              margin: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.green.withOpacity(1),
                                Colors.green.withOpacity(0.2)
                              ],
                            )),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 90,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      "Il tuo ordine è stato creato con successo!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          ModalRoute.withName("/Home"));
                    },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.green),
                    child: const Text(
                      "Fatto!",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )),
        );
      }

      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
