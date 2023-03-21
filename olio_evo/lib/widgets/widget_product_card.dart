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
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow( color: Colors.greenAccent, blurRadius: 15, spreadRadius: 10),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical:10, horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric( horizontal: 10, vertical: 10),
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
                        ),
                      ),
                    ), ),
                ),
                Flexible(
                  child: Stack(
                    alignment:Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xffE).withAlpha(40),
                      ),
                      Image.network(
                        data.images.length>0
                        ? data.images[0].src
                        :"https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930",

                        height: 100,
                      )
                    ],
                    ),
                ),
                SizedBox(height: 5),
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: data.salePrice!=data.regularPrice,
                          child:Text(
                      '${data.regularPrice}',
                      style: TextStyle(
                        fontSize: 14,
                        color:Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                        ),
                    Text(
                      '${data.salePrice}',
                      style: TextStyle(
                        fontSize: 14,
                        color:Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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