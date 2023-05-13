import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olio_evo/pages/base_page.dart';
import 'package:olio_evo/widgets/widget_product_card.dart';
import 'package:provider/provider.dart';

import '../api_service.dart';
import '../models/category.dart' hide Image;
import '../models/product.dart';
import '../provider/filters_provider.dart';
import '../provider/products_provider.dart';

class ProductPage extends BasePage {
  List<Category> categories;
  Category category;

  ProductPage({Key key, this.categories, this.category}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  API apiSerivce = new API();
  //servono per tenere l'ordinamento dei bottoni per la selezione dei filtri
  List<String> sortIndex = ["Ordina", "Categorie", "Regioni", "Consigliati"];
  List<String> myStrings = ['Elemento 1', 'Elemento 123242', 'Elemento 3'];
  int pageNumber = 1;
  int categoryId;
  //Tiene ttraccia se è stato selezionato un filtro o meno
  bool isFilter;
  ScrollController _scrollController = new ScrollController();
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  Future<List<Category>> categorieSaved;
  List<String> sortFilterStrings = [
    "Popolarità",
    "Novità",
    "Recensioni",
    "Nome"
  ];

  List<String> myFilters = ["", "", "", ""];

  final _sortByOptions = [
    SortBy("popularity", "Popularity", "asc"),
    SortBy("date", "Latest", "desc"),
    SortBy("rating", "Price: High to Low", "asc"),
    SortBy("title", "Price: Low to High", "desc"),
  ];

  @override
  void initState() {
    if(this.widget.category != null){
      categoryId = this.widget.category.categoryId;
      myFilters[1] = "Categorie: " + this.widget.category.categoryName;
      isFilter = true;
    }
    else{
      isFilter = false;
    }
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
    ;
  }

  //TODO: manca la parte in cui la ricerca ritorna nessun prodotto
  _onSearchChange() {
    var productsList = Provider.of<ProductProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      //TODO: manca la parte in cui la ricerca è fatta per sortorder e sortby
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
      Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Row(
          children: [
            Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 249, 249, 249),
                      border: Border.all(
                        width: 2,
                        // assign the color to the border color
                        color: Color.fromARGB(255, 250, 250, 250),
                      ),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: sortIndex.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 249, 249, 249),
                            ),
                            // height: 150,
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 249, 249, 249)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 12, 12, 12)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                      side: BorderSide(
                                        color: Color.fromARGB(255, 32, 172, 41),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  mouseCursor:
                                      MaterialStateProperty.all<MouseCursor>(
                                    SystemMouseCursors.click,
                                  ),
                                  elevation: MaterialStateProperty.all<double>(
                                      10), // Valore dell'ombra
                                  shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.black
                                        .withOpacity(0.5), // Colore dell'ombra
                                  ),
                                ),
                                onPressed: () {
                                  filterMenu(index);
                                },
                                child: Row(children: [
                                  Text(
                                    sortIndex[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 15,
                                  ),
                                ])),
                          );
                        }))),
          ],
        ),
      ),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 249, 249, 249),
                border: Border.all(
                  width: 2,
                  // assign the color to the border color
                  color: Color.fromARGB(255, 80, 148, 25),
                ),
              ),
              child: Center(
                child: Text("Filtri:",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 249, 249, 249),
                border: Border.all(
                  width: 2,
                  // assign the color to the border color
                  color: Color.fromARGB(255, 80, 148, 25),
                ),
              ),
              child: !isFilter
                  ? Text("Nessun filtro")
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: myFilters.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = myFilters[index];
                        return  data==""
                        ?  SizedBox.shrink()
                        :Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 249, 249, 249),
                              border: Border.all(
                                color: Color.fromARGB(255, 39, 146, 48),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[800],
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.only(left: 1.0, right: 1),
                            // il resto del contenuto del container
                            child: Center(
                              child: Text(
                                data,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }),
            ),
          ),
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
            color: Color.fromARGB(255, 44, 158, 50),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 82, 158, 55),
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        fillColor: Color.fromARGB(250, 252, 255, 252),
        filled: true,
      ),
    );
  }

  //getData(), // if you mean this method well return image url

  Widget _buildCategoryList(List<Category> categories) {
    return Consumer<SelectionState>(builder: (context, selectionState, _) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Text("Seleziona la categoria che preferisci:",
                textAlign: TextAlign.center,
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
              border:
                  Border.all(color: Color.fromARGB(77, 23, 11, 11), width: 1),
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
                          selectionState.updateIndexCategories(index);
                        },
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 0),
                            width: 90,
                            height: 110,
                            decoration: BoxDecoration(
                              color:
        categoryId == data.categoryId                                
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
                    isFilter = true;
                    myFilters[1] = "Categorie: " +
                        categories[selectionState.getIndexCategories()]
                            .categoryName
                            .toString();
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
    });
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
    return Consumer<SelectionState>(builder: (context, selectionState, _) {
       return Container(
              height: MediaQuery.of(context).size.height * 0.32,
              child: 
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Text(
              "Seleziona l'ordine che preferisci:",
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6.0),
                border:
                    Border.all(color: Color.fromARGB(77, 23, 11, 11), width: 1),
              ),
              child: GridView.count(
                childAspectRatio: 10,
                crossAxisSpacing: MediaQuery.of(context).size.width * 0.013,
                crossAxisCount: 1,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: List.generate(
                  sortFilterStrings.length,
                  (index) {
                    var data = sortFilterStrings[index];
                    return GestureDetector(
                      onTap: () {

                        selectionState.updateSelection(index);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 242, 243, 242),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color.fromARGB(255, 16, 17, 17),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            height: 40,
                            child: Center(
                              child: Text(
                                data,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontStyle: FontStyle.italic,
                                  color: selectionState.isSelected[index] == 0
                                      ? Color.fromARGB(255, 10, 10, 10)
                                      : Color.fromARGB(255, 48, 148, 41),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    child: Text('Applica'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 17, 162, 46),
                      side: BorderSide(
                        color: Color.fromARGB(255, 33, 32, 32),
                        width: 1,
                      ),
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 236, 239, 236),
                          fontSize: 20,
                          fontStyle: FontStyle.italic),
                    ),
                    onPressed: () {
                      setState(() {
                        isFilter = true;
                        myFilters[0] = "Ordine: " +
                            sortFilterStrings[selectionState.getIndex()]
                                .toString();
                        var _productsList = Provider.of<ProductProvider>(
                            context,
                            listen: false);
                        _productsList.resetStreams();
                        _productsList.setLoadingState(
                            LoadMoreStatus.INITIAL, true);
                        if (categoryId != null) {
                          _productsList.fetchProducts(pageNumber,
                              sortOrder:
                                  _sortByOptions[selectionState.getIndex()]
                                      .sortOrder,
                              sortBy: _sortByOptions[selectionState.getIndex()]
                                  .value,
                              categoryId: categoryId.toString());
                        } else {
                          _productsList.fetchProducts(
                            pageNumber,
                            sortOrder: _sortByOptions[selectionState.getIndex()]
                                .sortOrder,
                            sortBy:
                                _sortByOptions[selectionState.getIndex()].value,
                          );
                        }
                        Navigator.pop(context);
                      });
                    }))
          ])
        ],
      ),);
    });
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
        
              child: type == 1
                  ? _buildCategoryList(this.widget.categories)
                  : _buildFilterList());
        });
  }
}
