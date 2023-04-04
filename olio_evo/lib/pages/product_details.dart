import 'package:flutter/material.dart';
import 'package:olio_evo/pages/base_page.dart';
import 'package:olio_evo/widgets/widget_product_details.dart';

import '../models/product.dart';

class ProductDetails extends BasePage{
  ProductDetails({ Key key, this.product}) : super(key: key);

  Product product;
  
  @override
    _ProductDetailsState createState() => _ProductDetailsState();
  

}

class _ProductDetailsState extends BasePageState<ProductDetails>{

  @override
  Widget pageUI(){
    return ProductDetailsWidget(data: this.widget.product);

    
  }
}