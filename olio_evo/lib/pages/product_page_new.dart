import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olio_evo/pages/base_page.dart';
import 'package:olio_evo/widgets/widget_product_card.dart';
import 'package:provider/provider.dart';

import '../api_service.dart';
import '../models/category.dart' hide Image;
import '../models/product.dart';
import '../provider/products_provider.dart';

class ProductPageNEW extends BasePage {
  List<Category> categories;

  ProductPageNEW({Key key, this.categories}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPageNEW> {
  API apiSerivce = new API();
  //servono per tenere l'ordinamento dei bottoni per la selezione dei filtri
  List<String> sortIndex = ["Ordina", "Categorie", "Regioni", "Consigliati"];
  List<String> myStrings = ['Elemento 1', 'Elemento 123242', 'Elemento 3'];
  int pageNumber = 1;
  ScrollController _scrollController = new ScrollController();
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  Future<List<Category>> categorieSaved;
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
    _productList.fetchProducts(
      pageNumber,
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _productList.setLoadingState(LoadMoreStatus.LOADING, true);
        _productList.fetchProducts(++pageNumber);
      }
    });
    categorieSaved = apiSerivce.getCategories();
    super.initState();
  }

  //TODO: manca la parte in cui la ricerca ritorna nessun prodotto
  _onSearchChange() {
    var productsList = Provider.of<ProductProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      productsList.resetStreams();
      productsList.setLoadingState(LoadMoreStatus.INITIAL, true);
      productsList.fetchProducts(
        pageNumber,
        strSearch: _searchQuery.text,
      );
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
    return Column(children: [
      searchWidget(),
      Row(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 249, 249, 249),
                    border: Border.all(
                      width: 1,
                      // assign the color to the border color
                      color: Color.fromARGB(255, 12, 12, 12),
                    ),
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: myStrings.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 249, 249, 249),
                            border: Border.all(
                              width: 1,
                              // assign the color to the border color
                              color: Color.fromARGB(255, 12, 12, 12),
                            ),
                          ),
                          height: 100,
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              filterMenu(index);
                            },
                            child: Text(sortIndex[index]),
                          ),
                        );
                      }))),
        ],
      ),
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
          height: 60.0,
          width: 60.0,
          child: CircularProgressIndicator(),
        ),
        visible: isLoadMore,
      ),
    ]);
  }

  Widget searchWidget() {
    return TextField(
      controller: _searchQuery,
      decoration: InputDecoration(
        prefixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _onSearchChange();
          },
        ),
        hintText: "Search",
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        fillColor: Color.fromARGB(250, 252, 255, 252),
        filled: true,
      ),
    );
  }

  //getData(), // if you mean this method well return image url

  Widget _buildCategoryList(List<Category> categories) {
    int categoryId;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
          child: Text("Seleziona la categoria che preferisci:",
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              )),
        ),
        Container(
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
                        categoryId = data.categoryId;
                        // pageUI();
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                          width: 90,
                          height: 110,
                          decoration: BoxDecoration(
                            color: data.categoryId == categoryId
                                ? Color.fromARGB(255, 15, 115, 6)
                                : Color.fromARGB(
                                    255, 135, 209, 128), //inside color
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
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
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
        ),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: ElevatedButton(
                child: Text('Applica'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 17, 162, 46),
                  side: BorderSide(
                      color: Color.fromARGB(255, 33, 32, 32), width: 1),
                  textStyle: TextStyle(
                      color: Color.fromARGB(255, 236, 239, 236),
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
                onPressed: () {
                  var productsList =
                      Provider.of<ProductProvider>(context, listen: false);
                  productsList.resetStreams();
                  productsList.setLoadingState(LoadMoreStatus.INITIAL, true);
                  productsList.fetchProducts(pageNumber,
                      categoryId: categoryId.toString());
                  Navigator.pop(context);
                }))
      ],
    );
  }

//set the as first in the list the elemnt with categoryId == widget.categoryId
  List<Category> setFirstSelected(List<Category> categories) {
    if (categories != null) {
      var index = categories
          .indexWhere((element) => element.categoryId == categories[1]);
      if (index != -1) {
        var category = categories[index];
        categories.removeAt(index);
        categories.insert(0, category);
      }
    }
    return categories;
  }

  Widget _buildFilterList() {
    SortBy indexSorting;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Text("Seleziona l'ordine che preferisci:",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ))),
        // impostare un'altezza fissa
           Container(
            height: MediaQuery.of(context).size.height*0.1 ,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6.0),
              border:
                  Border.all(color: Color.fromARGB(77, 23, 11, 11), width: 1),
            ),
              child: GridView.count(
        shrinkWrap: true,
          crossAxisCount: 2,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,// Padding esterno
  children: List.generate(
    sortIndex.length, // Numero di elementi
    (index) {
    var data = sortIndex[index];
                  return Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: GestureDetector(
                        onTap: () {
                          indexSorting=_sortByOptions[index];                          
                        },
                       
                          child: Container(
                          
                          decoration: BoxDecoration(
        color: Color.fromARGB(255, 242, 243, 242),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow( color: Color.fromARGB(255, 160, 161, 161), blurRadius: 5, spreadRadius: 2),
        ],
      ),
                          height: 2,
                          child: Text(data,
                          style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                )),
                        ),
                      ));
                },
              ),
            ),
          
        
        ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: ElevatedButton(
                child: Text('Applica'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 17, 162, 46),
                  side: BorderSide(
                      color: Color.fromARGB(255, 33, 32, 32), width: 1),
                  textStyle: TextStyle(
                      color: Color.fromARGB(255, 236, 239, 236),
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
                onPressed: () {
                  var productsList =
                      Provider.of<ProductProvider>(context, listen: false);
                    var _productsList =
                    Provider.of<ProductProvider>(context, listen: false);
                _productsList.resetStreams();
                _productsList.setSortOrder(indexSorting);
                _productsList.fetchProducts(pageNumber);
                  Navigator.pop(context);
                }))
      ],
      
    );
  }

  Widget filterMenu(int type) {
    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 250, 250, 250),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        elevation: 100,
        context: context,
        isScrollControlled: true, // abilita lo scrolling
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: type == 1
                  ? _buildCategoryList(this.widget.categories)
                  : _buildFilterList());
        });
  }
}
