import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:olio_evo/pages/base_page.dart';
import 'package:olio_evo/provider/order_provider.dart';
import 'package:olio_evo/widgets/widget_order_item.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';

class OrdersPage extends BasePage {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends BasePageState<OrdersPage> {
  @override
  void initState() {
    super.initState();

    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();
  }

  @override
  Widget pageUI() {
    return Consumer<OrderProvider>(builder: (context, ordersModel, child) {
      if (ordersModel.allOrders != null && ordersModel.allOrders.isNotEmpty) {
        return _listView(context, ordersModel.allOrders);
      } else if (ordersModel.allOrders != null &&
          ordersModel.allOrders.isEmpty) {
        return const Center(
          child: Text('Non ci sono ordini presenti'),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _listView(BuildContext context, List<OrderModel> orders) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text('I miei ordini',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ),
        ListView.builder(
          itemCount: orders.length,
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              child: WidgetOrderItem(orderModel: orders[index]),
            );
          },
        )
      ],
    );
  }
}
