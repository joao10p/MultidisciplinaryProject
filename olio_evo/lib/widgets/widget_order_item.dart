import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:olio_evo/models/order.dart';
import 'package:olio_evo/pages/order_detail.dart';

class WidgetOrderItem extends StatelessWidget {
  OrderModel orderModel;

  WidgetOrderItem({this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        _orderStatus(orderModel.status),
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconText(
                const Icon(
                  Icons.receipt,
                  color: Color.fromARGB(255, 15, 176, 58),
                ),
                const Text(
                  "ID",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Text(
              orderModel.orderNumber.toString(),
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconText(
                const Icon(
                  Icons.today,
                  color: Color.fromARGB(255, 24, 165, 33),
                ),
                const Text(
                  "Data",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Text(
              orderModel.orderDate.toLocal().toString(),
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            textButton(
                Row(
                  children: const [
                    Text(
                      "Dettagli",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ],
                ),
                Colors.green, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(
                            orderID: orderModel.orderId,
                          )));
            })
          ],
        )
      ]),
    );
  }

  Widget iconText(Icon iconWidget, Text textWidget) {
    return Row(
      children: [
        iconWidget,
        const SizedBox(
          width: 10,
        ),
        textWidget
      ],
    );
  }

  Widget textButton(Widget iconText, Color color, Function onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: iconText,
    );
  }

  Widget _orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "pending" || status == "processing" || status == "on-hold") {
      icon = const Icon(Icons.timer, color: Color.fromARGB(255, 46, 155, 26));
      color = Color.fromARGB(255, 179, 75, 41);
    } else if (status == "completed") {
      icon = const Icon(
        Icons.check,
        color: Color.fromARGB(255, 6, 6, 6),
      );
    } else if (status == "cancelled" ||
        status == "refunded" ||
        status == "failed") {
      icon = const Icon(
        Icons.clear,
        color: Color.fromARGB(255, 28, 153, 43),
      );
      color = Color.fromARGB(255, 23, 165, 56);
    }

    return iconText(
        icon,
        Text(
          "Ordine ${getItalianStatusName(status)}",
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  String getItalianStatusName(String status) {
    switch (status) {
      case 'completed':
        return 'completato';
      case 'pending':
        return 'in attesa';
      case 'processing':
        return 'in fase di processo';
      case 'on-hold':
        return 'in attesa';
      case 'cancelled':
        return 'cancellato';
      case 'refunded':
        return 'rimborsato';
      case 'failed':
        return 'fallito';
    }
    return "";
  }
}
