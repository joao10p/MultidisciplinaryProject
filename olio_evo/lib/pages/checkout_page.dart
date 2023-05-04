import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/base_page.dart';
import '../provider/loader_provider.dart';
import '../utils/ProgressHUD.dart';

class CheckoutBasePage extends StatefulWidget {
  @override
  CheckoutBasePageState createState() => CheckoutBasePageState();
}

class CheckoutBasePageState<T extends CheckoutBasePage> extends State<T> {
  int currentPage = 0;
  bool showBackbutton = true;
  @override
  void initstate() {
    super.initState();
    print('CheckoutBasePage: initstate()');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _bulldAppar(),
          backgroundColor: Colors.white,
          body: ProgressHUD(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(color: Colors.grey),
                  pageUI(),
                ],
              ), // Column
            ), // SingleChildscrollview
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
          ), // ProgressHUD
        );
      },
    );
  }
}






Widget _bulldAppar() {
  return AppBar(
    centerTitle: true,
    brightness: Brightness.dark,
    elevation: 0,
    backgroundColor: Color.fromARGB(255, 68, 210, 25),
    automaticallyImplyLeading: true,
    title: Text(

      "Checkout",
      
      style: TextStyle(color: Colors.white),
      //metti  FontWeight.bold se vuoi il titolo in grassetto


    ),
    actions: <Widget>[],
  );
}
  

Widget pageUI() {
  return null;
}


