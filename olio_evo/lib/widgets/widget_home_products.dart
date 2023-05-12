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
      
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 249, 249, 249),
        
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget> [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                this.widget.labelName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 116, 30)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(color: Color.fromARGB(255, 5, 116, 30)),
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
      height: MediaQuery.of(context).size.height / 1.7, //altezza box
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
          return Container(
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
                    /*
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: IconButton(
                        icon: Icon(Icons.favorite_border_outlined),
                        onPressed: () {},
                        color: Color(0xff212435),
                        iconSize: 30,
                      ),
                    ),
                    */
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 3, 0),
                      child: Text(
                          data.rating.toString()== '0'
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
                      padding: EdgeInsets.fromLTRB(0, 21, 0, 0),
                      child: RatingBar.builder(
                        initialRating:   
                        data.rating.toDouble()==0
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
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: IconButton(
                        icon: Icon(Icons.add_shopping_cart_outlined),
                        onPressed: () {},
                        color: Color(0xff212435),
                        iconSize: 35,
                      ),
                    ),
                  ],
                ),
                Image.network(
                  data.images[0].src,
                  height: 100,
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 15, left: 4), //qui il nome del prodotto
                  width: 180,
                  alignment: Alignment.center,
                  child: Text(data.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                ),
                Container(
                  // qui il prezzo
                  margin: EdgeInsets.only(top: 4, left: 4),
                  width: 150,
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
          );
        },
      ),
    );
  }
}
