 import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olio_evo/utils/ProgressHUD.dart';

class BasePage extends StatefulWidget{

  BasePage({Key key}): super(key:key);
  @override
  State<StatefulWidget> createState() =>BasePageState();
  

}

class BasePageState<T extends BasePage> extends State<T>{
  bool isApiCallProcess=false;

  @override
  Widget build(BuildContext context) {
   return 
   Scaffold(
    appBar: _buildAppBar(),
    body: ProgressHUD(child: pageUI(),
     inAsyncCall: isApiCallProcess,
     opacity: 0.3, 
    )
   );
   
  }

  Widget pageUI(){
    return null;
  }


  

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: true,
      title: const Text(
        "OlivEvo",
        style: TextStyle(color: Colors.white),
      ),
      actions: const [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(
          width: 20,
        ),
        Icon(Icons.shopping_cart, color: Colors.white),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}


