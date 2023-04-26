import 'package:flutter/material.dart';
import 'package:olio_evo/models/cart_request_model.dart';

import '../api_service.dart';
import '../models/cart_response_model.dart';

class CartProvider with ChangeNotifier {
  API _api;
  List<CartItem> _cartItems;

  List<CartItem> get cartItems => _cartItems;
  double get totalRecords => _cartItems.length.toDouble();
  double get totalAmount => _cartItems != null
      ? _cartItems
          .map<double>((e) => e.lineSubtotal)
          .reduce((value, element) => value + element)
      : 0;

  CartProvider() {
    _api = API();
    _cartItems = <CartItem>[];
  }

  void resetStreams() {
    _api = API();
    _cartItems = <CartItem>[];
  }

  void addToCart(CartProducts product, Function onCallback) async {
    CartRequestModel requestModel = CartRequestModel();
    requestModel.products = <CartProducts>[];

    if (_cartItems == null) resetStreams();

    _cartItems.forEach((element) {
      requestModel.products.add(
          CartProducts(productId: element.productId, quantity: element.qty));
    });

    var isProductExist = requestModel.products.firstWhere(
      (prd) => prd.productId == product.productId,
      orElse: () => null,
    );

    if (isProductExist != null) {
      requestModel.products.remove(isProductExist);
    }

    requestModel.products.add(product);

    await _api.addToCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  fetchCartItems() async {
    if (_cartItems == null) resetStreams();

    await _api.getCartItems().then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems.addAll(cartResponseModel.data);
      }

      notifyListeners();
    });
  }

  void updateQty(int productId, int qty) {
    var isProductExist = _cartItems
        .firstWhere((prd) => prd.productId == productId, orElse: () => null);

    if (isProductExist != null) {
      isProductExist.qty = qty;
    }

    notifyListeners();
  }

  void updateCart(Function onCallback) async {
    CartRequestModel requestModel = CartRequestModel();
    requestModel.products = <CartProducts>[];

    if (_cartItems == null) resetStreams();

    _cartItems.forEach((element) {
      requestModel.products.add(
          CartProducts(productId: element.productId, quantity: element.qty));
    });

    await _api.addToCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  void removeItem(int productId) {
    var isProductExist = _cartItems
        .firstWhere((prd) => prd.productId == productId, orElse: () => null);

    if (isProductExist != null) {
      _cartItems.remove(isProductExist);
    }

    notifyListeners();
  }
}
