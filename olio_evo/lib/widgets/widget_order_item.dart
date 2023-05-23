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
                  color: Colors.redAccent,
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
                  color: Colors.redAccent,
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
      icon = const Icon(Icons.timer, color: Colors.orange);
      color = Colors.orange;
    } else if (status == "completed") {
      icon = const Icon(
        Icons.check,
        color: Colors.green,
      );
    } else if (status == "cancelled" ||
        status == "refunded" ||
        status == "failed") {
      icon = const Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
    }

    return iconText(
        icon,
        Text(
          "Ordine $status",
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
