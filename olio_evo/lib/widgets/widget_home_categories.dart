import 'package:flutter/material.dart';
import 'package:olio_evo/api_service.dart';

import '../models/category.dart' hide Image;

class WidgetCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WidgetCategoriesState();
}

class _WidgetCategoriesState extends State<WidgetCategories> {
  API apiSerivce;

  void initState() {
    apiSerivce = new API();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10),
                child: Text('Tutte le categorie',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
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
            ],
          ),
          _categoriesList()
        ],
      ),
    );
  }

  Widget _categoriesList() {
    return FutureBuilder<List<Category>>(
      future: apiSerivce
          .getCategories(), //getData(), // if you mean this method well return image url
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildCategoryList(snapshot.data);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return Container(
        height: 150,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var data = categories[index];
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 80,
                  child: Image.network(
                    "https://www.lucianopignataro.it/wp-content/uploads/2022/02/Olio-Campania-igt.jpg",
                    height: 80,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 5),
                          blurRadius: 15),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(data.categoryName.toString()),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 14,
                    )
                  ],
                )
              ],
            );
          },
        ));
  }
}
