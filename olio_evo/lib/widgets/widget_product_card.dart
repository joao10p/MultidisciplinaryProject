import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/product.dart';
import '../pages/product_details.dart';

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
        padding: EdgeInsets.all(2),
        //width: MediaQuery.of(context).size.width / 2.2,
        //height: MediaQuery.of(context).size.height / 0.5,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Color.fromARGB(255, 10, 10, 10), // Colore del bordo
            width: 1,
          ), // Larghezza del bordo
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 3,
            )
          ],
        ),
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
           /**  Visibility(
                  visible: data.calculateDiscount() > 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '${data.calculateDiscount()}% SCONTO',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                */
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 3, 0),
                  child: Text(
                    data.rating.toString() == '0'
                        ? '3.0'
                        : 'data.rating.toString()',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontWeight: FontWeight.w400,
                      //fontStyle: FontStyle.italic,
                      fontSize: 20,
                      color: Color.fromARGB(255, 94, 94, 94),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 12, 3, 0),
                  child: RatingBar.builder(
                    initialRating: data.rating.toDouble() == 0
                        ? 3
                        : data.rating.toDouble(),
                    unratedColor: Color(0xff9e9e9e),
                    itemBuilder: (context, index) =>
                        Icon(Icons.star, color: Color(0xffffc107)),
                    itemCount: 5, //numero stelline
                    itemSize: 20, //dimensione stelline
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    onRatingUpdate: (value) {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: IconButton(
                    icon: Icon(Icons.add_shopping_cart_outlined),
                    onPressed: () {},
                    color: Color(0xff212435),
                    iconSize: 30,
                  ),
                ),
              ],
            ),
            Image.network(
              data.images.length > 0
                  ? data.images[0].src
                  : "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930",
              height: MediaQuery.of(context).size.height*0.15,
            ),
            Container(
              margin:
                  EdgeInsets.only(top: 15, left: 4), //qui il nome del prodotto
              width: MediaQuery.of(context).size.width / 1,
              alignment: Alignment.center,
              child: Text(data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  )),
            ),
            Container(
              // qui il prezzo
              margin: EdgeInsets.only(top: 8, left: 4),
              width: MediaQuery.of(context).size.width / 5,
              alignment: Alignment.center,
              child: Text(
                data.salePrice != null && data.salePrice.isNotEmpty
                    ? 'In offerta: € ${data.salePrice}'
                    : '€ ${data.regularPrice}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SFPro',
                  fontSize: 18,
                  color: data.salePrice != null && data.salePrice.isNotEmpty
                      ? Colors.red
                      : Colors.black,
                  fontWeight:
                      data.salePrice != null && data.salePrice.isNotEmpty
                          ? FontWeight.w800
                          : FontWeight.w800,
                ),
              ),
            ),
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
      ),
    );
  }
}
