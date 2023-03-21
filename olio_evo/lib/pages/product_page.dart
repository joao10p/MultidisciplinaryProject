
import 'package:flutter/material.dart';
import 'package:olio_evo/pages/base_page.dart';
import 'package:olio_evo/widgets/widget_product_card.dart';
import 'package:provider/provider.dart';

import '../api_service.dart';
import '../models/product.dart';
import '../provider/products_provider.dart';



class ProductPage extends BasePage{
  int categoryId;

  ProductPage({Key key, this.categoryId}): super(key:key);
  @override
  State<StatefulWidget> createState()=> 
  _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage>{
  int pageNumber = 1;
  final _sortByOptions=[
    SortBy("popularity","Popularity", "asc"),
    SortBy("modified", "Latest", "asc"),
    SortBy("price", "Price: High to Low", "desc"),
    SortBy("price", "Price: Low to High", "asc"),

  ];

  @override
  void initState(){
    var _productList = Provider.of<ProductProvider>(context,listen:false);
    _productList.resetStreams();
     _productList.setLoadingState(LoadMoreStatus.INITIAL,false);
    _productList.fetchProducts(pageNumber);
    super.initState();
  }

  @override
  Widget pageUI(){
    return _productsList();
  }

  Widget _productsList(){
    return new Consumer<ProductProvider>(
      builder:(context,productsModel, child){
        if(productsModel.allProducts != null &&
        productsModel.allProducts.length >0 &&
          productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL
          )
      {
          return _buildList(productsModel.allProducts);
        }

        return Center(
          child: CircularProgressIndicator());
      }
    );
  }

  Widget _buildList(List<Product> items){

    return Column(children: [
      _productFilters(),
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
        )
    ],
    );
  }

  Widget _productFilters(){
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(children: [
        Flexible(child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Search",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none ),
              fillColor: Color.fromARGB(253, 22, 122, 74),
              filled: true,
          ),
        ),
        ),
        SizedBox(width: 15),
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(253, 22, 122, 74),
            borderRadius: BorderRadius.circular(9.0),
          ),
          child: PopupMenuButton(
            onSelected: (sortBy){

            },
            itemBuilder: (BuildContext context){
              return _sortByOptions.map((item){
                return PopupMenuItem(
                  value: item,
                  child : Container(
                    child: Text(item.text),
                  )
                );
              }).toList();
            },
              icon: Icon(Icons.tune),
          ),
          ),
        
          ],
      ),
    );

  }


}