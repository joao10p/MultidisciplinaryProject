import 'package:flutter/material.dart';
import 'package:olio_evo/pages/checkout_base.dart';
import 'package:olio_evo/pages/paypal_payment.dart';
import 'package:provider/provider.dart';

import '../models/paymet_method.dart';
import '../provider/cart_provider.dart';
import '../widgets/widget_method_list_item.dart';

class PaymentScreen extends CheckoutBasePage {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends CheckoutBasePageState<PaymentScreen> {
  PaymentMethodList list;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
  }

  /*
  @override
  Widget pageUI() {
    list = PaymentMethodList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 15),
          list.paymentsList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.payment,
                      color: Theme.of(context).hintColor,
                    ), // Icon
                    title: Text(
                      "Payment Options",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ), // Text

                    subtitle: const Text(
                        "Seleziona il tuo metodo di pagamento preferito"),
                  ),
                )
              : const SizedBox(height: 0),
          const SizedBox(height: 10),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return PaymentMethodListItem(
                  paymentMethod: list.paymentsList.elementAt(index));
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: list.paymentsList.length,
          ),
          const SizedBox(height: 15),
          list.cashList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.monetization_on,
                      color: Theme.of(context).hintColor,
                    ), // Icon
                    title: Text(
                      "Contante alla consegna",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ), // Text

                    subtitle: const Text(
                        "Seleziona il tuo metodo di pagamento preferito"),
                  ),
                )
              : const SizedBox(height: 0),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return PaymentMethodListItem(
                  paymentMethod: list.cashList.elementAt(index));
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: list.cashList.length,
          ),
        ],
      ),
    );
  }
  */

  @override
  Widget pageUI() {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalAmount = cartProvider.totalAmount;
    final totalItemsCost = cartProvider.totalItemCost;
    final speditionCost = cartProvider.speditionCost;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 40, 0, 0),
                  child: Text(
                    "Dettagli pagamento",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Prezzo",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          color: Color(0x80000000),
                        ),
                      ),
                      Text(
                        "€ ${totalItemsCost.toStringAsFixed(2)}", //checkout carrello
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          color: Color(0x7f000000),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Spedizione",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0x7f000000),
                        ),
                      ),
                      Text(
                        "€ ${speditionCost.toStringAsFixed(2)}", //costi spedizione (?)
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0x7f000000),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Totale",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.normal,
                          fontSize: 24,
                          color: Color(0xff000000),
                        ),
                      ),
                      Text(
                        "€ ${totalAmount.toStringAsFixed(2)}", //costi spedizione + checkout carrello
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.normal,
                          fontSize: 24,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: Text(
                    "Seleziona metodo di pagamento",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaypalPaymentScreen(context),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: const BorderSide(
                            color: Color(0xff808080), width: 1),
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Image(
                              image: AssetImage("assets/images/paypal.png"),
                              width: 30),
                        ),
                        Text(
                          "Paga con PayPal",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: const BorderSide(
                            color: Color(0xff808080), width: 1),
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(
                            Icons.credit_card_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Text(
                          "Paga con carta di credito",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 75, 0, 0),
                  child: Text(
                    "Consegna prevista entro:",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff8a8a8a),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "25 Giugno", //data consegna
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 22,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
