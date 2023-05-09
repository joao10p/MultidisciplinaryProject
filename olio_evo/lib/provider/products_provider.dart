import 'package:flutter/material.dart';
import 'package:olio_evo/models/product.dart';

import '../api_service.dart';

class SortBy{
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text,this.sortOrder);
}

enum LoadMoreStatus{INITIAL, LOADING , STABLE}

class ProductProvider with ChangeNotifier{

  API apiService;
  List <Product> _productList;
  SortBy _sortBy;

  int pageSize = 10;

  List<Product> get allProducts => _productList;
  double get totalRecords => _productList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider(){
    _sortBy = SortBy("modified", "Latest", "asc");
  }

  void resetStreams(){
    apiService= API();
    _productList = List<Product>();
  }

  setLoadingState(LoadMoreStatus loadMoreStatus, bool notify){
    _loadMoreStatus= loadMoreStatus;
    if(notify)
    notifyListeners();
  }
  
  setSortOrder(SortBy sortBy){
    _sortBy= sortBy;
    notifyListeners();
  }

  fetchProducts(pageNumber, {
    String strSearch,
    String tagName,
    String categoryId,
    String sortBy,
    String sortOrder="asc",
    }) async {
    List <Product> itemModel= await apiService.getProducts(
      strSearch: strSearch,
      tagName: tagName,
      pageNumber: pageNumber,
      pageSize: pageSize,
      categoryId: categoryId,
      sortBy:sortBy,
      sortOrder:  sortOrder
    );

    if(itemModel!=null && itemModel.length > 0){
      _productList.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.STABLE, true);
      }




}