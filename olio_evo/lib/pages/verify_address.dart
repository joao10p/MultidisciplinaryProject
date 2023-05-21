import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olio_evo/models/customer_detail_model.dart';
import 'package:olio_evo/pages/payment_screen.dart';
import 'package:olio_evo/provider/cart_provider.dart';
import 'package:olio_evo/utils/former_helper.dart';
import 'package:provider/provider.dart';

import 'checkout_base.dart';

class VerifyAddress extends CheckoutBasePage {
  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckoutBasePageState<VerifyAddress> {
  @override
  void initState() {
    super.initState();
    currentPage = 0;
  }

  @override
  Widget pageUI() {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
    return Consumer<CartProvider>(builder: (context, customerModel, child) {
      if (customerModel.customerDetailsModel.id != null) {
        return _formUI(customerModel.customerDetailsModel);
      }

      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _formUI(CustomerDetailsModel model) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.topLeft,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("First Name")),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Last Name"))
              ]),
              Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child:
                          FormHelper.fieldLabelValue(context, model.firstName)),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FormHelper.fieldLabelValue(
                              context, model.lastName)))
                ],
              ),
              FormHelper.fieldLabel("Address"),
              FormHelper.fieldLabelValue(context, model.shipping.address1),
              FormHelper.fieldLabel("Apartment, etc."),
              FormHelper.fieldLabelValue(context, model.shipping.address2),
              Row(children: [
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Country")),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("State"))
              ]),
              Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabelValue(
                          context, model.shipping.country)),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FormHelper.fieldLabelValue(
                              context, model.shipping.state)))
                ],
              ),
              Row(children: [
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("City")),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Postcode"))
              ]),
              Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabelValue(
                          context, model.shipping.city)),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FormHelper.fieldLabelValue(
                              context, model.shipping.postcode)))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: FormHelper.saveButton("Next", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()));
              })),
            ]),
          )),
    );
  }
}
