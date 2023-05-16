import 'package:flutter/material.dart';
import 'package:olio_evo/pages/checkout_base.dart';

import '../models/paymet_method.dart';
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
}
