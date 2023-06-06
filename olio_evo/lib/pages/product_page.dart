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

class ProductPage extends StatefulWidget {
  List<Category> categories;
  Category category;

  ProductPage({Key key, this.categories, this.category}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  API apiSerivce = new API();
  //servono per tenere l'ordinamento dei bottoni per la selezione dei filtri
  List<String> sortIndex = ["Ordina", "Sapori", "Regioni", "Consigliati"];
  List<String> myStrings = ['Elemento 1', 'Elemento 123242', 'Elemento 3'];
  int pageNumber = 1;
  //Tiene traccia dell'id dell sapori
  String saporiId;
  //Tiene traccia dell'id della regione
  String categoryId;
  //Tiene ttraccia se è stato selezionato un filtro o meno
  bool isFilter;
  ScrollController _scrollController = new ScrollController();
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  List<Category> categorieSaved;
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
    isFilter = false;

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
  Widget build(BuildContext context) {
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
      Padding(
        padding: EdgeInsets.only(top: 2),
        child: searchWidget(),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(4, 2, 6, 0),
        child: Row(
          children: [
            Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 249, 249, 249),
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
                            padding: EdgeInsets.all(4),

                            /// questo modifica la grandezza del container
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                                      1), // Valore dell'ombra
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 25,
                                  ),
                                ])),
                          );
                        }))),
          ],
        ),
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 6, 0),
          child: Row(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  //height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text("Filtri applicati: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: !isFilter
                      ? Padding(
                          padding: EdgeInsets.only(left: 8, top: 20),
                          child: Text("Nessun filtro applicato"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: myFilters.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = myFilters[index];
                            return data == ""
                                ? SizedBox.shrink()
                                : Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.only(top: 3),
                                      // il resto del contenuto del container
                                      child: Center(
                                        child: Text(
                                          data,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
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
          )),
      Flexible(
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: GridView.count(
            crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            childAspectRatio: 0.8,
            children: items.map((Product item) {
              return ProductCard(
                data: item,
              );
            }).toList(),
          ),
        ),
      ),
      Visibility(
        child: Container(
          padding: EdgeInsets.all(2),
          height: 60.0,
          width: 60.0,
          child: CircularProgressIndicator(),
        ),
        visible: isLoadMore,
      ),
    ]);
  }

  Widget searchWidget() {
    return Padding(
      padding: EdgeInsets.all(6),
      child: TextField(
        controller: _searchQuery,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: Color.fromARGB(255, 44, 158, 50),
            ),
            iconSize: 30,
            onPressed: () {
              _onSearchChange();
            },
          ),
          hintText: "Cerca un prodotto",
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 135, 137, 134),
            fontSize: 16,
            fontStyle: FontStyle.normal,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          fillColor: Color.fromARGB(250, 252, 255, 252),
          filled: true,
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }

  Widget _saporiList() {
    return FutureBuilder<List<Category>>(
      future: apiSerivce
          .getSapori(), //getData(), // if you mean this method well return image url
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          categorieSaved = snapshot.data;
          return _buildCategoryList(snapshot.data, true, null);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  //getData(), // if you mean this method well return image url

  Widget _buildCategoryList(List<Category> categories, isSapori, name) {
    return Consumer<SelectionState>(builder: (context, selectionState, _) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 20, 10, 30),
                    child: Text(
                      name == null
                          ? "Scegli la caratteristica desiderata"
                          : name,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        //chiudi il popup
                      },
                      iconSize: 45,
                      icon: Icon(Icons.close_rounded),
                      color: Colors.black,
                    ))
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  var data = categories[index];
                  return Padding(
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isFilter = true;
                              if(isSapori){
                                saporiId = data.categoryId.toString();
                                myFilters[1] = "" + data.categoryName.toString();
                              }
                              else{
                                categoryId = data.categoryId.toString();
                                myFilters[2] = "" + data.categoryName.toString();
                              }
                              var productsList = Provider.of<ProductProvider>(
                                  context,
                                  listen: false);
                              productsList.resetStreams();
                              productsList.setLoadingState(
                                  LoadMoreStatus.INITIAL, true);
                              if (selectionState.getIndex() != -1 &&
                                  categoryId != null &&
                                  saporiId == null) {
                                productsList.fetchProducts(
                                  pageNumber,
                                  sortOrder:
                                      _sortByOptions[selectionState.getIndex()]
                                          .sortOrder,
                                  sortBy:
                                      _sortByOptions[selectionState.getIndex()]
                                          .value,
                                  categoryId: categoryId,
                                );
                              } else if (selectionState.getIndex() == -1 &&
                                  categoryId != null &&
                                  saporiId == null) {
                                productsList.fetchProducts(
                                  pageNumber,
                                  categoryId: categoryId,
                                );
                              } else if (selectionState.getIndex() != -1 &&
                                  categoryId != null &&
                                  saporiId != null) {
                                productsList.fetchProducts(
                                  pageNumber,
                                  sortOrder:
                                      _sortByOptions[selectionState.getIndex()]
                                          .sortOrder,
                                  sortBy:
                                      _sortByOptions[selectionState.getIndex()]
                                          .value,
                                  categoryId: categoryId + "," + saporiId,
                                );
                              } else if (selectionState.getIndex() == -1 &&
                                  categoryId == null &&
                                  saporiId != null) {
                                productsList.fetchProducts(
                                  pageNumber,
                                  categoryId: saporiId,
                                );
                              } else if (selectionState.getIndex() == -1 &&
                                  categoryId != null &&
                                  saporiId != null) {
                                productsList.fetchProducts(
                                  pageNumber,
                                  categoryId: categoryId + "," + saporiId,
                                );
                              }
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              padding: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.30,
                              decoration: BoxDecoration(
                                color: Colors.black12, //inside color
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 2), // border color
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                      ),
                                      child: Image.network(
                                        data.image.url,
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
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w800,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 13,
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
        ),
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

  Widget _categoriesList(String parent, String name, BuildContext MainContext) {
    return FutureBuilder<List<Category>>(
      future: apiSerivce.getCategories(
          parent), //getData(), // if you mean this method well return image url
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          categorieSaved = snapshot.data;
          return _buildCategoryList(snapshot.data, false, name);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _saporiListBuilder() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.9, // Larghezza desiderata del popup
              height: MediaQuery.of(context).size.height *
                  0.6, // Altezza desiderata del popup
              padding: EdgeInsets.all(5), // Imposta il padding del popup
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_saporiList()],
              ),
            ),
          );
        });
  }

  Widget _regioniList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.9, // Larghezza desiderata del popup
              height: MediaQuery.of(context).size.height * 0.60,
              child: Stack(
                children: [
                  Positioned(
                    child: Image(
                      image: AssetImage("assets/images/mappa_italia.jpg"),
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //spazio tra i due bottoni
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 30, 0, 20),
                        child: Text(
                          "Scegli in quale zona cercare ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              //chiudi il popup
                            },
                            iconSize: 40,
                            icon: Icon(Icons.close_rounded),
                            color: Colors.black,
                          ))
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.09,
                    left: 5,
                    right: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4 / 3,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent // Opacità personalizzabile

                              ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.9, // Larghezza desiderata del popup
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: _categoriesList("49", "Nord Italia",
                                        context), //50 is the id
                                  ),
                                );
                              });
                          // Logica da eseguire quando viene premuto il secondo bottone
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.225,
                    left: 5,
                    right: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3 / 3,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent // Opacità personalizzabile

                                ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9, // Larghezza desiderata del popup
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: _categoriesList(
                                          "50",
                                          "Centro Italia",
                                          context) //50 is the id
                                      ),
                                );
                              },
                            );
                          }),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.327,
                    left: 5,
                    right: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.55 / 3,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent // Opacità personalizzabile

                                ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9, // Larghezza desiderata del popup
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: _categoriesList("51", "Sud Italia",
                                          context) //50 is the id
                                      ),
                                );
                              },
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildFilterList() {
    return Consumer<SelectionState>(builder: (context, selectionState, _) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.start, //spazio tra i due bottoni
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 30, 0, 20),
                  child: Text(
                    "Scegli in quale ordine cercare ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        //chiudi il popup
                      },
                      iconSize: 35,
                      icon: Icon(Icons.close_rounded),
                      color: Colors.black,
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: GridView.count(
                  childAspectRatio: 5,
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
                          padding: EdgeInsets.all(2.5),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: selectionState.isSelected[index] == 0
                                      ? Colors.black
                                      : Colors.green,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  data,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.normal,
                                    color: selectionState.isSelected[index] == 0
                                        ? Colors.black
                                        : Colors.green,
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
              MaterialButton(
                  color: Colors.green,
                  minWidth: 120,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Applica",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  textColor: Color(0xffffffff),
                  onPressed: () {
                    setState(() {
                      isFilter = true;
                      myFilters[0] = "" +
                          sortFilterStrings[selectionState.getIndex()]
                              .toString();
                      var _productsList =
                          Provider.of<ProductProvider>(context, listen: false);
                      _productsList.resetStreams();
                      _productsList.setLoadingState(
                          LoadMoreStatus.INITIAL, true);
                      if (categoryId != null) {
                        _productsList.fetchProducts(pageNumber,
                            sortOrder: _sortByOptions[selectionState.getIndex()]
                                .sortOrder,
                            sortBy:
                                _sortByOptions[selectionState.getIndex()].value,
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
                  }),
            ])
          ],
        ),
      );
    });
  }

  Widget filterMenu(int type) {
    switch (type) {
      case 1:
        _saporiListBuilder();
        break;
      case 0:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // Larghezza desiderata del popup
                    height: MediaQuery.of(context).size.height *
                        0.6, // Altezza desiderata del popup
                    padding: EdgeInsets.all(5), // Imposta il padding del popup
                    child: _buildFilterList()));
          },
        );
        break;
      case 2:
        _regioniList();
        break;
    }
  }
}
