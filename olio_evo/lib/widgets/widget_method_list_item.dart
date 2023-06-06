import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olio_evo/pages/payment_screen.dart';

import '../models/paymet_method.dart';
import '../pages/paypal_payment.dart';

class PaymentMethodListItem extends StatelessWidget {
  PaymentMethod paymentMethod;
  PaymentMethodListItem({Key key, this.paymentMethod}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        if (this.paymentMethod.isRouteRedirect) {
         Navigator.push(context, new MaterialPageRoute(
  builder: (context) =>
     new PaypalPaymentScreen(context))
  );
        } else {
          this.paymentMethod.onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ), // BoxShadow
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ), // BorderRadius.all
              image: DecorationImage(
                image: AssetImage(paymentMethod.logo),
                fit: BoxFit.fill,
              ), // Decoration Image
            ), // BoxDecoration
          ), // Container

          SizedBox(width: 15),
          Flexible(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.subtitle1,
                    ), // Text
                    Text(
                      paymentMethod.description,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.caption,
                    ), // Text
                    SizedBox(width: 8),
                    Icon(Icons.keyboard_arrow_right,
                        color: Theme.of(context).focusColor),
                  ]),
            )
          ]))
        ]), // Column// BoxDecoration
        
      ),
    ); // InkWell
  }
}
