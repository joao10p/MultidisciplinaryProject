import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/product.dart';
import '../pages/product_details.dart';

import '../models/cart_request_model.dart';
import '../provider/cart_provider.dart';
import '../provider/loader_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  ProductCard({Key key, this.data}) : super(key: key);

  Product data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              product: data,
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(0),
        //width: MediaQuery.of(context).size.width / 2.2,
        //height: MediaQuery.of(context).size.height / 0.5,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 3,
            )
          ],
          border: Border.all(
            color: Colors.green,
            width: 1.7,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 20, 0, 0),
                  child: Image.network(
                    data.images[0].src,
                    height: 100,
                    width: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                  child: IconButton(
                    icon: Icon(Icons.add_shopping_cart_outlined),
                    onPressed: () {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(true);
                      var cartProvider =
                          Provider.of<CartProvider>(context, listen: false);
                      CartProducts cartProducts = new CartProducts();

                      cartProducts.productId = data.id;
                      cartProducts.quantity = 1;
                      cartProvider.addToCart(cartProducts, (val) {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(false);
                        print(val);
                      });
                    },
                    color: Color(0xff212435),
                    iconSize: 30,
                  ),
                ),
              ],
            ),
            Container(
              margin:
                  EdgeInsets.fromLTRB(0, 20, 0, 0), //qui il nome del prodotto
              width: MediaQuery.of(context).size.width * 0.4,
              alignment: Alignment.center,
              child: Text(data.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 3, 0),
                  child: Text(
                    data.rating.toString() == '0'
                        ? '3.0'
                        : data.rating.toString(),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontWeight: FontWeight.w400,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Color.fromARGB(255, 94, 94, 94),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                  child: RatingBar.builder(
                    initialRating: data.rating.toDouble() == 0
                        ? 3
                        : data.rating.toDouble(),
                    unratedColor: Color(0xff9e9e9e),
                    itemBuilder: (context, index) =>
                        Icon(Icons.star, color: Color(0xffffc107)),
                    itemCount: 1, //numero stelline
                    itemSize: 20, //dimensione stelline
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    onRatingUpdate: (value) {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Container(
                    // qui il prezzo
                    padding: EdgeInsets.all(0),
                    //bordi rotondi
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: data.salePrice != null && data.salePrice.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '€ ${data.regularPrice}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: 'SFPro',
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 150, 149, 149),
                                  fontWeight: data.salePrice != null &&
                                          data.salePrice.isNotEmpty
                                      ? FontWeight.w800
                                      : FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Text(
                                '€ ${data.salePrice}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SFPro',
                                  fontSize: 24,
                                  color: data.salePrice != null &&
                                          data.salePrice.isNotEmpty
                                      ? Colors.red
                                      : Colors.black,
                                  fontWeight: data.salePrice != null &&
                                          data.salePrice.isNotEmpty
                                      ? FontWeight.w800
                                      : FontWeight.w800,
                                ),
                              )
                            ],
                          )
                        : Text(
                            '€ ${data.regularPrice}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 24,
                              color: data.salePrice != null &&
                                      data.salePrice.isNotEmpty
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: data.salePrice != null &&
                                      data.salePrice.isNotEmpty
                                  ? FontWeight.w800
                                  : FontWeight.w800,
                            ),
                          ),
                  ),
                )

                /* riga con icone sapori
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                        icon: Icon(Icons.workspace_premium),
                        onPressed: () {},
                        color: Color(0xff212435),
                        iconSize: 1,
                      ),
                    ),
                  ],
                ),
                */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
