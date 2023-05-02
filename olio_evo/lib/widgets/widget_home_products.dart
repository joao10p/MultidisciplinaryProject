import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:olio_evo/api_service.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

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
                  fontSize: 20,
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
      height: 350,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var data = items[index];

          return Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            width: 200,
            height: 220,
            alignment: Alignment.center,
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
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: Text(
                          data.rating.toString()== '0'
                        ? '3'
                        : 'data.rating.toString()',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
                      child: RatingBar.builder(
                        initialRating:   
                        data.rating.toDouble()==0
                        ? 3
                        : data.rating.toDouble(),
                        unratedColor: Color(0xff9e9e9e),
                        itemBuilder: (context, index) =>
                            Icon(Icons.star, color: Color(0xffffc107)),
                        itemCount: 5, //numero stelline
                        itemSize: 15, //dimensione stelline
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        onRatingUpdate: (value) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () {},
                        color: Color(0xff212435),
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
                Image.network(
                  data.images[0].src,
                  height: 170,
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 4, left: 4), //qui il nome del prodotto
                  width: 180,
                  alignment: Alignment.center,
                  child: Text(data.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
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
                      fontSize: 14,
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
          );
        },
      ),
    );
  }
}
