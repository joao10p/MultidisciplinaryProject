import 'package:flutter/material.dart';

import '../models/product.dart';
import '../pages/product_details.dart';

class ProductCard extends StatelessWidget{

  ProductCard({Key key, this.data}) : super(key: key);

  Product data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetails(
          product: data,
        ),
        ),
        );
      },
    
    child: Container(
     // width: 300,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 242, 243, 242),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow( color: Color.fromARGB(255, 160, 161, 161), blurRadius: 5, spreadRadius: 2),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical:2, horizontal: 5),
      child: Container(
        padding: EdgeInsets.symmetric( horizontal: 0, vertical: 0),
        child: Stack(
          alignment:Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Visibility(
                  visible: data.calculateDiscount() > 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding:EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '${data.calculateDiscount()}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ), ),
                ),
                Container(
                  child: Stack(
                    alignment:Alignment.center,
                    children: <Widget>[
                     
                      Image.network(
                        data.images.length>0
                        ? data.images[0].src
                        :"https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930",

                        height: 100,
                      )
                    ],
                    ),
                ),
               
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  Container(
                  // qui il prezzo
                  margin: EdgeInsets.only(top: 4, left: 4),
                  width: 170,
                  alignment: Alignment.center,
                  child: Text(
                    data.salePrice != null && data.salePrice.isNotEmpty
                        ? 'In offerta: ${data.salePrice} € '
                        : '${data.regularPrice} €',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: data.salePrice != null && data.salePrice.isNotEmpty
                          ? Colors.red
                          : Colors.black,
                      fontWeight:
                          data.salePrice != null && data.salePrice.isNotEmpty
                              ? FontWeight.bold
                              : FontWeight.bold,
                    ),
                  ),
                ),
                  ],
                  ),
              ],
            ),
           ),
      ),
    );
  }

}