import 'package:flutter/material.dart';
import 'package:olio_evo/api_service.dart';

import '../models/product.dart';
import '../pages/product_details.dart';

class WidgetRelatedProducts extends StatefulWidget {
  bool hasFired = false;

  WidgetRelatedProducts({
    this.labelName,
    this.products,
  });

  String labelName;
  List<int> products;

  @override
  State<StatefulWidget> createState() => WidgetRelatedProductsState();
}

class WidgetRelatedProductsState extends State<WidgetRelatedProducts> {
  API apiService;

  @override
  void initState() {
    apiService = new API();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, top: 4),
              child: Text(
                this.widget.labelName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Vedi tutti',
                  style: TextStyle(color: Colors.black,
                  fontSize: 15,
                  decoration: TextDecoration.underline,),
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
    if (!this.widget.hasFired) {
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
  }

  Widget _buildList(List<Product> items) {
    this.widget.hasFired = true;
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: MediaQuery.of(context).size.height * 0.35,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            var data = items[index];
            return Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
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
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.2,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                alignment: Alignment.center,
                                child: Image.network(
                                  data.images[0].src,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white,
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              alignment: Alignment.centerLeft,
                              child: Text(data.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4, left: 4),
                              width: MediaQuery.of(context).size.width * 0.25,
                              alignment: Alignment.centerLeft,
                              child: data.salePrice != null &&
                                      data.salePrice.isNotEmpty
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '€ ${data.regularPrice}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontFamily: 'SFPro',
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 150, 149, 149),
                                            fontWeight: data.salePrice !=
                                                        null &&
                                                    data.salePrice.isNotEmpty
                                                ? FontWeight.w800
                                                : FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        Text(
                                          '€ ${data.salePrice}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'SFPro',
                                            fontSize: 18,
                                            color: data.salePrice != null &&
                                                    data.salePrice.isNotEmpty
                                                ? Colors.red
                                                : Colors.black,
                                            fontWeight: data.salePrice !=
                                                        null &&
                                                    data.salePrice.isNotEmpty
                                                ? FontWeight.w800
                                                : FontWeight.w800,
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '€ ${data.regularPrice}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'SFPro',
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                            )
                          ],
                        ))));
          },
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
      ),
    ]);
  }
}
