import 'package:flutter/material.dart';
import 'package:olio_evo/models/product.dart';
import 'package:olio_evo/pages/base_page.dart';
import 'package:olio_evo/pages/cart_page.dart';
import 'package:olio_evo/pages/home_page.dart';
import 'package:olio_evo/pages/login_page.dart';
import 'package:olio_evo/pages/orders_page.dart';
import 'package:olio_evo/pages/paypal_payment.dart';
import 'package:olio_evo/pages/product_details.dart';
import 'package:olio_evo/pages/product_page.dart';
import 'package:olio_evo/pages/sign_up_page.dart';
import 'package:olio_evo/provider/cart_provider.dart';
import 'package:olio_evo/provider/filters_provider.dart';
import 'package:olio_evo/provider/loader_provider.dart';
import 'package:olio_evo/provider/order_provider.dart';
import 'package:olio_evo/provider/products_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [   
          ChangeNotifierProvider(create: (context) => SelectionState()),

          ChangeNotifierProvider(
            create: (context) => ProductProvider(),
            child: ProductPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => LoaderProvider(),
            child: BasePage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: ProductDetails(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: const CartPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => OrderProvider(),
            child: OrdersPage(),
          ),
        ],
        child: MaterialApp(
          title: 'OlivEvo',
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          initialRoute: "/",
          routes: <String, WidgetBuilder>{
            "/PayPal": (context) => new PaypalPaymentScreen(context)
          },
        ));
  }
}
