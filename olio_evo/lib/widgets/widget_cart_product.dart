import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:olio_evo/models/cart_response_model.dart';
import 'package:olio_evo/provider/cart_provider.dart';
import 'package:olio_evo/utils/utils.dart';
import 'package:provider/provider.dart';

import '../pages/cart_page.dart';
import '../provider/loader_provider.dart';
import '../utils/custom_stepper.dart';

class CartProduct extends StatelessWidget {
  CartProduct({this.data});
  CartItem data;

  @override
  Widget build(BuildContext context) {
    return makeListTitle(context);
  }

  ListTile makeListTitle(BuildContext context) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        leading: Container(
          width: 50,
          height: 150,
          alignment: Alignment.center,
          child: Image.network(
            data.thumbnail,
            height: 150,
          ),
        ),
        title: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              data.productName,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )),
        subtitle: Padding(
          padding: const EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                "€${data.productSalePrice.toString()}",
                style: const TextStyle(color: Colors.black),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("OlivEvo"),
                          content: Text("Do you want to delete this item?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Provider.of<LoaderProvider>(context,
                                          listen: false)
                                      .setLoadingStatus(true);

                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeItem(data.productId);

                                  Provider.of<LoaderProvider>(context,
                                          listen: false)
                                      .setLoadingStatus(false);

                                  Navigator.of(context).pop();
                                },
                                child: const Text("Yes")),
                            Visibility(
                                visible: true,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("No"),
                                ))
                          ],
                        );
                      });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: Colors.redAccent,
                  shape: const StadiumBorder(),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.delete, color: Colors.white, size: 20),
                      Text("Remove", style: TextStyle(color: Colors.white))
                    ]),
              ),
            ],
          ),
        ),
        trailing: Container(
            width: 120,
            child: CustomStepper(
              lowerLimit: 0,
              upperLimit: 20,
              stepValue: 1,
              iconSize: 22.0,
              value: data.qty,
              onChanged: (value) {
                Provider.of<CartProvider>(context, listen: false)
                    .updateQty(data.productId, value);
              },
            )),
      );
}
