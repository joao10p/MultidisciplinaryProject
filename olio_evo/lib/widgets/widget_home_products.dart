import 'package:flutter/material.dart';
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
      height: 320,
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
                  width: 170,
                  height: 220,
                  alignment: Alignment.center,
                  child: Image.network(
                    data.images[0].src,
                    height: 200,
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
              Container( //qui il nome del prodotto
                width: 180,
                alignment: Alignment.center,
                child: Text(data.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    )),
              ),
              Container( // qui il prezzo
                margin: EdgeInsets.only(top: 4, left: 4),
                width: 180,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                                  //I want to make this two widget Visibility, visible only if the data.salePrice is not empty
                                          
                     Visibility(
                        child: Text(
                      'Prezzo: ${data.regularPrice}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                        maintainSize: true, 
                        maintainAnimation: true,
                        maintainState: true,
                        visible: data.salePrice=="",
                      ),
                    
                    Visibility(
                        child: Text(
                      'In Offerta: ${data.salePrice}',
                      style: TextStyle(
                        
                        fontSize: 14,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                        maintainSize: true, 
                        maintainAnimation: true,
                        maintainState: true,
                        visible: data.salePrice!="", 
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
