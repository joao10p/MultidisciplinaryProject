import 'package:flutter/material.dart';
import 'package:olio_evo/pages/login_page.dart';
import 'package:olio_evo/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class UnAuthWidget extends StatelessWidget {
  const UnAuthWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, loginModel, child) {
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
                          Colors.green.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 90,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              //const Opacity(
              //opacity: 0.6,
              /*child:*/ const Text(
                "You must be logged in to access this page",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              //),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.green),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
