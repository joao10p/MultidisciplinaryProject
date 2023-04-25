import 'package:flutter/material.dart';
import 'package:olio_evo/models/product.dart';
import 'package:olio_evo/pages/home_page.dart';
import 'package:olio_evo/pages/paypal_payment.dart';
import 'package:olio_evo/pages/product_page.dart';
import 'package:olio_evo/pages/signup_page.dart';
import 'package:olio_evo/provider/products_provider.dart';
import 'package:provider/provider.dart';

import 'pages/login_page.dart';
import 'pages/pagina_prova.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ProductProvider(),
            child: ProductPage(),
          )
        ],
        child: MaterialApp(
            title: 'OlivEvo',
            debugShowCheckedModeBanner: false,
            home: HomePage(),
            initialRoute: "/",
            routes: <String, WidgetBuilder>{
              "/PayPal": (context) => new PaypalPaymentScreen()
            } 
            ,
            )

            );
  }
}
