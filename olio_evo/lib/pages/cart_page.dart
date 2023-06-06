import 'package:flutter/material.dart';
import 'package:olio_evo/pages/verify_address.dart';
import 'package:olio_evo/provider/cart_provider.dart';
import 'package:olio_evo/provider/loader_provider.dart';
import 'package:olio_evo/shared_service.dart';
import 'package:olio_evo/utils/ProgressHUD.dart';
import 'package:olio_evo/widgets/unauth_cart_widget.dart';
import 'package:olio_evo/widgets/widget_cart_product.dart';
import 'package:provider/provider.dart';

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
        if (loginModel.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (loginModel.hasData) {
          if (loginModel.data) {
            return Consumer<LoaderProvider>(
              builder: (context, loaderModel, child) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: _buildAppBar(),
                  body: ProgressHUD(
                    inAsyncCall: loaderModel.isApiCallProcess,
                    opacity: 0.3,
                    child: _buildCartBody(),
                  ),
                );
              },
            );
          } else {
            return UnAuthCartWidget();
          }
        } else {
          return const Center(
            child: Text('Error occurred'),
          );
        }
      },
    );
  }

  Widget _buildCartBody() {
    return Consumer<CartProvider>(
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
                        return CartProduct(
                          data: cartModel.cartItems[index],
                        );
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
                            "Salva carrello",
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
                              "Totale",
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyAddress()));
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: const BorderSide(
                                  color: Colors.redAccent, width: 2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Checkout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (cartModel.cartItems.isEmpty) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 30),
              child: Image.asset(
                "assets/images/empty_cart.png",
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                  shape: const StadiumBorder(),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      "Torna allo shopping",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]);
        } else {
          return const Center(
            child: Text('Error occurred'),
          );
        }
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: true,
      title: const Text(
        "Carrello",
        style: TextStyle(color: Colors.white),
      ),
      actions: const <Widget>[],
    );
  }
}
