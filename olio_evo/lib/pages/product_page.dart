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

  _onSearchChange() {
    var productsList = Provider.of<ProductProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      productsList.resetStreams();
      productsList.setLoadingState(LoadMoreStatus.INITIAL, true);
      productsList.fetchProducts(pageNumber, strSearch: _searchQuery.text);
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
         Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child:  
         _categoriesList()),
        
        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child:  
       _productFilters()),
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
                fillColor: Color.fromARGB(251, 55, 172, 57),
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(252, 68, 146, 52),
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
          return _buildCategoryList(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return Container(
      height: 100,
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
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductPage(categoryId: data.categoryId)));
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  width: 250,
                  height: 100,
                  decoration: BoxDecoration(
                    color: widget.categoryId==data.categoryId? Color.fromARGB(255, 13, 136, 46):Color.fromARGB(255, 135, 209, 128) , //inside color
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                        color: Color.fromARGB(77, 16, 16, 16),
                        width: 1), // border color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Container(
                          width: 100,
                          height: 70,
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
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Container(
                          width: 80,
                          child: 
                            Text(
                              data.categoryName.toString(),
                             textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                          
                        ),
                      )
                    ],

                    /*   Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
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
                    height: 80,
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
            ),
          );
        },
      ),
    );
    */
                  )));
        },
      ),
    );
  }
}
