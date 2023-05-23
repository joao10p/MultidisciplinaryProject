import 'package:flutter/material.dart';
import 'package:olio_evo/models/cart_request_model.dart';
import 'package:olio_evo/models/customer_detail_model.dart';
import 'package:olio_evo/models/order.dart';
import 'package:olio_evo/shared_service.dart';

import '../api_service.dart';
import '../models/cart_response_model.dart';

class CartProvider with ChangeNotifier {
  API _api;
  List<CartItem> _cartItems;
  CustomerDetailsModel _customerDetailsModel;
  OrderModel _orderModel;
  bool _isOrderCreated = false;

  List<CartItem> get cartItems => _cartItems;
  double get totalRecords => _cartItems.length.toDouble();
  double get totalItemCost => _cartItems != null && _cartItems.isNotEmpty
      ? _cartItems
          .map<double>((e) => e.lineSubtotal)
          .reduce((value, element) => value + element)
      : 0;
  double get speditionCost => 0;
  double get totalAmount => totalItemCost + speditionCost;

  CustomerDetailsModel get customerDetailsModel => _customerDetailsModel;
  OrderModel get orderModel => _orderModel;
  bool get isOrderCreated => _isOrderCreated;

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
    bool isLoggedIn = await SharedService.isLoggedIn();

    if (_cartItems == null) resetStreams();

    if (isLoggedIn) {
      await _api.getCartItems().then((cartResponseModel) {
        if (cartResponseModel.data != null) {
          _cartItems.clear();
          _cartItems.addAll(cartResponseModel.data);
        }

        notifyListeners();
      });
    }
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

  fetchShippingDetails() async {
    if (_customerDetailsModel == null) {
      _customerDetailsModel = CustomerDetailsModel();
    }

    _customerDetailsModel = await _api.customerDetails();
    notifyListeners();
  }

  processOrder(OrderModel orderModel) {
    _orderModel = orderModel;
    notifyListeners();
  }

  void createOrder() async {
    if (_orderModel.shipping == null) {
      _orderModel.shipping = Shipping();
    }

    if (customerDetailsModel.shipping != null) {
      _orderModel.shipping = customerDetailsModel.shipping;
    }

    if (_orderModel.lineItems == null) {
      _orderModel.lineItems = <LineItems>[];
    }

    _cartItems.forEach((v) {
      _orderModel.lineItems
          .add(LineItems(productId: v.productId, quantity: v.qty));
    });

    await _api.createOrder(orderModel).then((value) {
      if (value) {
        _isOrderCreated = true;
        notifyListeners();
      }
    });
  }
}
