import 'package:flutter/material.dart';
import 'package:olio_evo/api_service.dart';

import '../models/product.dart';

class WidgetRelatedProducts extends StatefulWidget{
  
  WidgetRelatedProducts({
    this.labelName,
    this.products,
  });

  String labelName;
  List<int> products;

  @override
  State<StatefulWidget> createState() => WidgetRelatedProductsState();

}

class WidgetRelatedProductsState extends State<WidgetRelatedProducts>{

  API apiService;

  @override
  void initState(){
    apiService = new API();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, top: 4),
              child: Text(
                this.widget.labelName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 4),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
            )
          ],
        ),
        _productsList(),
      ]),
    );
  }

  Widget _productsList() {
    return new FutureBuilder(
        future: apiService.getProducts(productsIDs: this.widget.products),
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
      height: 220,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var data = items[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(10),
                  width: 130,
                  height: 120,
                  alignment: Alignment.center,
                  child: Image.network(
                    data.images[0].src,
                    height: 120,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      )
                    ],
                  )),
              Container(
                width: 130,
                alignment: Alignment.centerLeft,
                child: Text(data.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 4, left: 4),
                width: 130,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      '${data.regularPrice}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${data.salePrice}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
