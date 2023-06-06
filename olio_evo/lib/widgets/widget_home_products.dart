import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:olio_evo/api_service.dart';
import 'package:intl/intl.dart';
import 'package:olio_evo/pages/product_page.dart';
import '../models/product.dart';
import '../pages/product_details.dart';
import 'package:provider/provider.dart';
import '../models/cart_request_model.dart';
import '../provider/cart_provider.dart';
import '../provider/loader_provider.dart';

class WidgetHomeProducts extends StatefulWidget {
  String labelName;
  String tagId;

  WidgetHomeProducts({Key key, this.labelName, this.tagId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetHomeProductState();
}

class _WidgetHomeProductState extends State<WidgetHomeProducts> {
  API apiService;

  @override
  void initState() {
    apiService = new API();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Text(
                    this.widget.labelName,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Vedi tutti',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _productsListHome(this.widget.tagId),
          ]),
    );
  }

  Widget _productsListHome(String tagId) {
    return new FutureBuilder(
        future: apiService.getProducts(tagName: tagId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildList(snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildList(List<Product> items) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.75, //altezza box
      alignment: Alignment.center,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          var data = items[index];
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
                  border: Border.all(
                    color: Colors.green,
                    width: 1.7,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 0),
                      blurRadius: 3,
                    )
                  ],
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
                              Provider.of<LoaderProvider>(context,
                                      listen: false)
                                  .setLoadingStatus(true);
                              var cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false);
                              CartProducts cartProducts = new CartProducts();

                              cartProducts.productId = data.id;
                              cartProducts.quantity = 1;
                              cartProvider.addToCart(cartProducts, (val) {
                                Provider.of<LoaderProvider>(context,
                                        listen: false)
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
                      margin: EdgeInsets.fromLTRB(
                          0, 20, 0, 0), //qui il nome del prodotto
                      width: MediaQuery.of(context).size.width * 0.6,
                      alignment: Alignment.center,
                      child: Text(data.name,
                          textAlign: TextAlign.center,
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
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                          child: Container(
                            // qui il prezzo
                            padding: EdgeInsets.all(0),
                            //bordi rotondi
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width * 0.25,
                            alignment: Alignment.center,
                            child: data.salePrice != null &&
                                    data.salePrice.isNotEmpty
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '€ ${data.regularPrice}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontFamily: 'SFPro',
                                          fontSize: 24,
                                          color: Color.fromARGB(
                                              255, 150, 149, 149),
                                          fontWeight: data.salePrice != null &&
                                                  data.salePrice.isNotEmpty
                                              ? FontWeight.w800
                                              : FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
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
              ));
        },
      ),
    );
  }
}
