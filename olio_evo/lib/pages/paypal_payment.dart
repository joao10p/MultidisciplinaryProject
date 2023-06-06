import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:olio_evo/models/order.dart';
import 'package:olio_evo/pages/checkout_base.dart';
import 'package:olio_evo/provider/cart_provider.dart';
import 'package:olio_evo/utils/paypal_service.dart';
import 'package:olio_evo/widgets/widget_order_success.dart';
import 'package:provider/provider.dart';

class PaypalPaymentScreen extends CheckoutBasePage {
  BuildContext paypalScreenContext;
  PaypalPaymentScreen(this.paypalScreenContext);
  @override
  _PaypalPaymentScreenState createState() => _PaypalPaymentScreenState();
}

class _PaypalPaymentScreenState
    extends CheckoutBasePageState<PaypalPaymentScreen> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  GlobalKey<ScaffoldState> scaffoldKey;

  String checkoutURL;
  String executeURL;
  String accessToken;

  PaypalServices paypalServices;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
    paypalServices = PaypalServices();
    this.scaffoldKey = GlobalKey<ScaffoldState>();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await paypalServices.getAccessToken();

        final transactions = paypalServices.getOrderParams(context);
        final res =
            await paypalServices.createPaypalPayment(transactions, accessToken);

        if (res != null) {
          setState(() {
            checkoutURL = res["approvalUrl"];
            executeURL = res["executeUrl"];
          });
        }
      } catch (e) {
        print('Exception: ' + e.toString());
      }
    });
  }

  @override
  Widget pageUI() {
    if (checkoutURL != null) {
      return Scaffold(
        key: scaffoldKey,
        /* appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true, */
        /* title: Text(
            "Paypal Payment",
            style: Theme.of(context).textTheme.headline6.merge(const TextStyle(
                  letterSpacing: 1.3,
                )),
          ), 
        ), */
        body: Stack(
          children: [
            InAppWebView(
              initialUrl: checkoutURL,
              initialOptions: InAppWebViewGroupOptions(
                  android: AndroidInAppWebViewOptions(textZoom: 120)),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart:
                  (InAppWebViewController controller, String requestUrl) async {
                if (requestUrl.contains(paypalServices.returnURL)) {
                  final uri = Uri.parse(requestUrl);
                  final payerId = uri.queryParameters['PayerID'];
                  if (payerId != null) {
                    await paypalServices
                        .executePayment(executeURL, payerId, accessToken)
                        .then((id) {
                          Navigator.of(this.widget.paypalScreenContext).pop();
                      print(id);
                      var orderProvider =
                          Provider.of<CartProvider>(context, listen: false);
                      OrderModel orderModel = OrderModel();
                      orderModel.paymentMethod = "paypal";
                      orderModel.paymentMethodTitle = "PayPal";
                      orderModel.setPaid = true;
                      orderModel.transactionId = id.toString();
                      orderProvider.processOrder(orderModel);
                      
                      Navigator.of(this.widget.paypalScreenContext).push(
                        MaterialPageRoute(
                            builder: (context) => OrderSuccessWidget()),
                      );
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                  //  Navigator.of(context).pop();
                }
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
            progress < 1
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      );
    } else {
      return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Paypal Payment",
              style:
                  Theme.of(context).textTheme.headline6.merge(const TextStyle(
                        letterSpacing: 1.3,
                      )),
            ),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    }
  }
}
