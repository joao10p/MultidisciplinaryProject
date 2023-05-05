import 'package:flutter/material.dart';
import 'package:olio_evo/api_service.dart';
import 'package:olio_evo/models/product.dart';

import '../models/category.dart' hide Image;
import '../pages/product_page.dart';
import '../pages/product_page_new.dart';

class WidgetCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WidgetCategoriesState();
}

class _WidgetCategoriesState extends State<WidgetCategories> {
  API apiSerivce;
  List<Category> categorieSalvate;
  void initState() {
    apiSerivce = new API();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18, 0, 0, 15),
                child: Text(
                  "Categorie",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 26,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 15),
                child: Text(
                  "Vedi tutto",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color.fromARGB(255, 26, 97, 8),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
            child: _categoriesList(),
          ),
        ],
      ),
    );

    /* Padding(
                padding: EdgeInsets.only(left: 16, top: 10),
                child: Text('I tuoi preferiti',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10),
                child: Text('All categories',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
              */
  }

  Widget _categoriesList() {
    return FutureBuilder<List<Category>>(
      future: apiSerivce
          .getCategories(), //getData(), // if you mean this method well return image url
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          categorieSalvate=snapshot.data;
          return _buildCategoryList(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: Color.fromARGB(77, 23, 11, 11), width: 1),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var data = categories[index];
          return Padding(padding:EdgeInsets.only(left: 5) ,child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductPageNEW(categories: categorieSalvate)));
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 135, 209, 128), //inside color
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                        color: Color.fromARGB(77, 16, 16, 16),
                        width: 1), // border color
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 5),
                                  blurRadius: 15),
                            ],
                          ),
                          child: Image.network(
                            data.image.url,
                            width: MediaQuery.of(context).size.width * 0.01,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            data.categoryName.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      )
                    ],
                  ))));
        },
      ),
    );
  }

}
