import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olio_evo/pages/base_page.dart';
import 'package:olio_evo/widgets/widget_product_card.dart';
import 'package:provider/provider.dart';

import '../api_service.dart';
import '../models/category.dart' hide Image;
import '../models/product.dart';
import '../provider/products_provider.dart';

class ProductPage extends BasePage {
  int categoryId;

  ProductPage({Key key, this.categoryId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  API apiSerivce = new API();
  int pageNumber = 1;
  ScrollController _scrollController = new ScrollController();
  final _searchQuery = new TextEditingController();
  Timer _debounce;

  final _sortByOptions = [
    SortBy("popularity", "Popularity", "asc"),
    SortBy("modified", "Latest", "asc"),
    SortBy("price", "Price: High to Low", "desc"),
    SortBy("price", "Price: Low to High", "asc"),
  ];

  @override
  void initState() {
    var _productList = Provider.of<ProductProvider>(context, listen: false);
    _productList.resetStreams();
    _productList.setLoadingState(LoadMoreStatus.INITIAL, false);
    _productList.fetchProducts(pageNumber,
        categoryId: this.widget.categoryId.toString());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _productList.setLoadingState(LoadMoreStatus.LOADING, true);
        _productList.fetchProducts(++pageNumber);
      }
    });

    super.initState();
  }
//TODO: manca la parte in cui la ricerca ritorna nessun prodotto
  _onSearchChange() {
    var productsList = Provider.of<ProductProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      productsList.resetStreams();
      productsList.setLoadingState(LoadMoreStatus.INITIAL, true);
      productsList.fetchProducts(pageNumber, strSearch: _searchQuery.text, categoryId: this.widget.categoryId.toString());
    });
  }

  @override
  Widget pageUI() {
    return _productsList();
  }

  Widget _productsList() {
    return new Consumer<ProductProvider>(
        builder: (context, productsModel, child) {
      if (productsModel.allProducts != null &&
          productsModel.allProducts.length > 0 &&
          productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return _buildList(productsModel.allProducts,
            productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
      }

      return Center(child: CircularProgressIndicator());
    });
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    return Column(
      children: [
        //Text in italic with writtent "Seleziona la categoria in cui cercare", colore verde
        Text(
          "Seleziona la categoria in cui cercare",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 22,
              color: Color.fromARGB(255, 3, 3, 3),
              fontWeight: FontWeight.bold),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5), child: _categoriesList()),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5), child: _productFilters()),
        Flexible(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: items.map((Product item) {
              return ProductCard(
                data: item,
              );
            }).toList(),
          ),
        ),
        Visibility(
          child: Container(
              padding: EdgeInsets.all(5),
              height: 35.0,
              width: 35.0,
              child: CircularProgressIndicator()),
          visible: isLoadMore,
        )
      ],
    );
  }

  Widget _productFilters() {
    return Container(
      height: 51,
      color: Colors.greenAccent,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _searchQuery,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _onSearchChange();
                  },
                ),
                hintText: "Search",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none),
                fillColor: Color.fromARGB(250, 252, 255, 252),
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(249, 40, 177, 13),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: PopupMenuButton(
              onSelected: (sortBy) {
                var _productsList =
                    Provider.of<ProductProvider>(context, listen: false);
                _productsList.resetStreams();
                _productsList.setSortOrder(sortBy);
                _productsList.fetchProducts(pageNumber);
              },
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map((item) {
                  return PopupMenuItem(
                      value: item,
                      child: Container(
                        child: Text(item.text),
                      ));
                }).toList();
              },
              icon: Icon(Icons.tune),
            ),
          ),
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
          return _buildCategoryList(setFirstSelected(snapshot.data));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return Container(
      height: 110,
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
          return Padding(
              padding: EdgeInsets.only(left: 5),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductPage(categoryId: data.categoryId)));
                    // pageUI();
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                      width: 90,
                      height: 110,
                      decoration: BoxDecoration(
                        color: data.categoryId == widget.categoryId
                            ? Color.fromARGB(255, 15, 115, 6)
                            : Color.fromARGB(255, 135, 209, 128), //inside color
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
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                data.categoryName.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
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

//set the as first in the list the elemnt with categoryId == widget.categoryId
  List<Category> setFirstSelected(List<Category> categories) {
    if (widget.categoryId != null) {
      var index = categories
          .indexWhere((element) => element.categoryId == widget.categoryId);
      if (index != -1) {
        var category = categories[index];
        categories.removeAt(index);
        categories.insert(0, category);
      }
    }
    return categories;
  }
}
