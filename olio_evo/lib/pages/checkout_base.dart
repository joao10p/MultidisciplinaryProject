import 'package:flutter/material.dart';
import 'package:olio_evo/provider/loader_provider.dart';
import 'package:olio_evo/utils/ProgressHUD.dart';
import 'package:olio_evo/utils/widget_checkpoints.dart';
import 'package:provider/provider.dart';

class CheckoutBasePage extends StatefulWidget {
  const CheckoutBasePage({Key key}) : super(key: key);

  @override
  State<CheckoutBasePage> createState() => CheckoutBasePageState();
}

class CheckoutBasePageState<T extends CheckoutBasePage> extends State<T> {
  int currentPage = 0;
  bool showBackButton = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: ProgressHUD(
          inAsyncCall: loaderModel.isApiCallProcess,
          opacity: 0.3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: CheckPoints(
                  checkedTill: currentPage,
                  checkPoints: const [
                    "Spedizione",
                    "Pagamento",
                    "Ordine",
                  ],
                  checkPointFilledColor: Colors.green,
                ),
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: pageUI(),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: showBackButton,
      title: const Text(
        "Checkout",
        style: TextStyle(color: Colors.white),
      ),
      actions: const <Widget>[],
    );
  }

  Widget pageUI() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
