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
                    child: FormHelper.fieldLabel("Nome")),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Cognome"))
              ]),
              Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child:
                          FormHelper.textInput(context, model.firstName, (val) {
                        model.firstName = val;
                      })),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FormHelper.textInput(context, model.lastName,
                              (val) {
                            model.lastName = val;
                          })))
                ],
              ),
              FormHelper.fieldLabel("Indirizzo"),
              FormHelper.textInput(context, model.shipping.address1, (val) {
                model.shipping.address1 = val;
              }),
              FormHelper.fieldLabel("Piano"),
              FormHelper.textInput(context, model.shipping.address2, (val) {
                model.shipping.address2 = val;
              }),
              Row(children: [
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Stato")),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Città"))
              ]),
              Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.textInput(
                          context, model.shipping.country, (val) {
                        model.shipping.country = val;
                      })),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FormHelper.textInput(
                              context, model.shipping.state, (val) {
                            model.shipping.state = val;
                          })))
                ],
              ),
              Row(children: [
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("Comune")),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.fieldLabel("CAP"))
              ]),
              Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.textInput(context, model.shipping.city,
                          (val) {
                        model.shipping.city = val;
                      })),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FormHelper.textInput(
                              context, model.shipping.postcode, (val) {
                            model.shipping.postcode = val;
                          })))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: FormHelper.saveButton("Avanti", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()));
              })),
            ]),
          )),
    );
  }
}
