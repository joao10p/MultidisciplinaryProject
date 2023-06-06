import 'package:flutter/material.dart';
import 'package:olio_evo/api_service.dart';
import 'package:olio_evo/pages/base_page.dart';
import 'package:olio_evo/utils/widget_checkpoints.dart';

import '../config.dart';
import '../models/order_details.dart';

class OrderDetailsPage extends BasePage {
  int orderID;

  OrderDetailsPage({Key key, this.orderID}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends BasePageState<OrderDetailsPage> {
  API api;

  @override
  void initState() {
    super.initState();
    api = API();
  }

  @override
  Widget pageUI() {
    return FutureBuilder(
      future: api.getOrderDetails(widget.orderID),
      builder: (BuildContext context,
          AsyncSnapshot<OrderDetailModel> orderDetailModel) {
        if (orderDetailModel.hasData) {
          return orderDetailUI(orderDetailModel.data);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget orderDetailUI(OrderDetailModel model) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "#${model.orderId}",
              style: Theme.of(context).textTheme.labelHeading,
            ),
            Text(
              model.orderDate.toString(),
              style: Theme.of(context).textTheme.labelText,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Indirizzo di spedizione:",
              style: Theme.of(context).textTheme.labelHeading,
            ),
            Text(
              
              "Piazza Duomo 13",
              style: Theme.of(context).textTheme.labelText,
            ),
         
            const SizedBox(
              height: 20,
            ),
            Text(
              "Metodo di pagamento: ",
              style: Theme.of(context).textTheme.labelHeading,
            ),
            Text(model.paymentMethod,
                style: Theme.of(context).textTheme.labelText),
            const Divider(color: Colors.grey),
            const SizedBox(
              height: 5,
            ),
            CheckPoints(
              checkedTill: 0,
              checkPoints: ["Elaborazione", "Spedito", "Consegnato"],
              checkPointFilledColor: Color.fromARGB(255, 41, 160, 55),
            ),
            const Divider(
              color: Colors.grey,
            ),
            _listOrderItems(model),
            const Divider(
              color: Colors.grey,
            ),
            _itemTotal(
                "Totale prodotto", model.itemTotalAmount.toStringAsFixed(2),
                textStyle: Theme.of(context).textTheme.itemTotalText),
            _itemTotal(
                "Costo di spedizione", model.shippingTotal.toStringAsFixed(2),
                textStyle: Theme.of(context).textTheme.itemTotalText),
            _itemTotal("Totale", model.totalAmount.toStringAsFixed(2),
                textStyle: Theme.of(context).textTheme.itemTotalPaidText),
          ]),
    );
  }

  Widget _listOrderItems(OrderDetailModel model) {
    return ListView.builder(
      itemCount: model.lineItems.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _productItems(model.lineItems[index]);
      },
    );
  }

  Widget _productItems(LineItems product) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.all(2),
      onTap: () {},
      title: Text(product.productName,
          style: Theme.of(context).textTheme.productItemText),
      subtitle: Padding(
        padding: const EdgeInsets.all(1),
        child: Text("Quantità: ${product.quantity}"),
      ),
      trailing:
          Text("${Config.currency} ${product.totalAmount.toStringAsFixed(2)}"),
    );
  }

  Widget _itemTotal(String label, String value, {TextStyle textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: const EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: Text(
        label,
        style: textStyle,
      ),
      trailing: Text("${Config.currency} $value"),
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle get labelHeading {
    return const TextStyle(
        fontSize: 16, color: Color.fromARGB(255, 43, 177, 63), fontWeight: FontWeight.bold);
  }

  TextStyle get labelText {
    return const TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
  }

  TextStyle get productItemText {
    return const TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700);
  }

  TextStyle get itemTotalText {
    return const TextStyle(fontSize: 14, color: Colors.black);
  }

  TextStyle get itemTotalPaidText {
    return const TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold);
  }
}
