import 'package:flutter/cupertino.dart';
import 'package:olio_evo/api_service.dart';

import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  API _api;

  List<OrderModel> _orderList;
  List<OrderModel> get allOrders => _orderList;
  double get totalRecords => _orderList.length.toDouble();

  OrderProvider() {
    resetStreams();
  }

  void resetStreams() {
    _api = API();
  }

  fetchOrders() async {
    List<OrderModel> orderList = await _api.getOrders();

    if (_orderList == null) {
      _orderList = <OrderModel>[];
    }
    if (orderList.length > 0) {
      _orderList = [];
      _orderList.addAll(orderList);
    }

    notifyListeners();
  }
}
