import 'dart:math';

import 'package:flutter/material.dart';
import 'package:olio_evo/api_service.dart';
import 'package:olio_evo/models/product.dart';
import 'package:olio_evo/pages/home_page.dart';

import '../models/category.dart' hide Image;
import '../pages/product_page.dart';
import '../pages/product_page.dart';

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

  //navigare alla product page
  /*
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductPage(categories: categorieSalvate,)),
    );  },
  */

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 249, 249, 249),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
              border:
                  Border.all(color: Colors.white, width: 0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
              Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
    padding: EdgeInsets.all(5),
    width: MediaQuery.of(context).size.width * 0.45,
    decoration: BoxDecoration(
      color: Color(0xffffffff),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(6.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 0),
          blurRadius: 3,
        )
      ],
    ),
    child:  ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
  onPressed: () {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Larghezza desiderata del popup
            height: MediaQuery.of(context).size.height * 0.8, // Altezza desiderata del popup
            padding: EdgeInsets.all(5), // Imposta il padding del popup
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _categoriesList()              
              ],
            ),
          ),
        );
      },
    );
  },
  
    // Logica da eseguire quando il primo bottone viene premuto

  child:Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
          child: Image(
            image: AssetImage("assets/images/sapori_image.png"),
            height: 60,
            width: MediaQuery.of(context).size.width * 0.15,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          "Sapore",
          textAlign: TextAlign.start,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontFamily: "SFPro",
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xff000000),
          ),
        ),
      ],
    ),
  ),
),

Container(
    margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
    padding: EdgeInsets.all(5),
    width: MediaQuery.of(context).size.width * 0.45,
    height: 90,
    decoration: BoxDecoration(
      color: Color(0xffffffff),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(6.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 0),
          blurRadius: 30,
        )
      ],
    ),
   child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
  onPressed: () {
    // Logica da eseguire quando il primo bottone viene premuto
  },
  child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Image(
            image: AssetImage("assets/images/regions_image.png"),
            height: 60,
            width: MediaQuery.of(context).size.width * 0.15,
            fit: BoxFit.fitHeight,
          ),
        ),
        Text(
          "Regioni",
          textAlign: TextAlign.start,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontFamily: "SFPro",
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xff000000),
          ),
        ),
      ],
    ),
  ),
),

                ],
            ),
          ),
        ],
      )

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
    );
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.75,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: Color.fromARGB(77, 255, 255, 255), width: 1),
      ),
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
            child: Text(
              "Scegli la caratteristica desiderata",
              softWrap: true,
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xff000000),
              ),
            ),
          ),
          IconButton(onPressed: (){
            //chiudi il popup
          },
          iconSize: 40,
          icon: Icon(Icons.close_rounded),
          color: Colors.black,
          )
          ],),
          Expanded(
            child:
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var data = categories[index];
                return Padding(padding:EdgeInsets.all(5) ,child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductPage(categories: categorieSalvate, category: data )));
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.30,
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
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.14,
                                height: MediaQuery.of(context).size.width * 0.12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1),
                                        blurRadius: 1,
                                        spreadRadius: 0.1),
                                  ],
                                ),
                                child: Image.network(
                                  data.image.url,
                                  //width: MediaQuery.of(context).size.width * 0.01,
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
                                    fontFamily:'SFPro',
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ))));
                },
              ),
            ),
        ],
      )
      );
  }

}
